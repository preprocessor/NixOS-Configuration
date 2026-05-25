{
  envoy = {
    yazi-plugins-repo.github = "yazi-rs/plugins";
    fuzzy-search-src.github = "onelocked/fuzzy-search.yazi";
  };

  w.shell =
    {
      pkgs,
      lib,
      envoy,
      ...
    }:
    let
      inherit (lib) getExe;

      zoom = envoy.yazi-plugins-repo.src + "/zoom.yazi";

      fuzzy-search = pkgs.yaziPlugins.mkYaziPlugin {
        inherit (envoy.fuzzy-search-src) pname version;

        src = lib.cleanSourceWith {
          inherit (envoy.fuzzy-search-src) src;
          filter = name: type: (baseNameOf name == "main.lua");
        };
      };

      confirm-dialog = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "confirm-dialog";
        version = "1.0";
        src = pkgs.writeTextFile {
          name = "confirm-dialog-src";
          destination = "/main.lua";
          text = # lua
            ''
              local get_hovered = ya.sync(function()
                  local h = cx.active.current.hovered
                  if not h then return nil end
                  return {
                      url     = tostring(h.url),
                      is_dir  = h.cha.is_dir,
                      exists  = h.cha.len ~= nil,
                  }
              end)

              local function entry()
                  if not os.getenv("YAZI_CHOOSER_SAVE") then
                      return ya.emit("open", { hovered = true })
                  end

                  local h = get_hovered()
                  if not h then return end

                  if h.is_dir then
                      return ya.emit("enter", {})
                  end

                  if h.exists then
                      local yes = ya.confirm({
                          pos   = { "center", w = 62, h = 10 },
                          title = "Overwrite file?",
                          body  = ui.Text(
                              h.url .. "\n\nThis file already exists and will be overwritten."
                          ):wrap(ui.Wrap.YES),
                      })
                      if not yes then return end
                  end

                  ya.emit("open", { hovered = true })
              end

              return { entry = entry }
            '';
        };
      };

    in
    {
      wrappers.yazi.initLua = /* lua */ ''
        require("starship"):setup()

        require("git"):setup {
        	order = 1500, -- Order of status signs showing in the line mode
        }

        require("smart-enter"):setup {
          open_multi = true, -- Allow open to target multiple selected files
        }
      '';

      wrappers.yazi.plugins = {
        inherit (pkgs.yaziPlugins)
          lazygit
          bypass
          git
          jump-to-char
          smart-filter
          smart-enter
          starship
          ouch
          restore
          toggle-pane
          piper
          chmod
          ;
        inherit zoom fuzzy-search confirm-dialog;
      };

      wrappers.yazi.settings = {
        plugin.prepend_previewers =
          let
            bat = "${getExe pkgs.bat} -p --color=always";
            qemu-img = lib.getExe' pkgs.qemu-utils "qemu-img";
          in
          with pkgs;
          [
            {
              url = "*.md";
              run = ''piper -- CLICOLOR_FORCE=1 ${getExe glow} -w=$w -s=dark -- "$1"'';
            }
            {
              mime = "text/*";
              run = ''piper -- ${bat} "$1"'';
            }
            {
              mime = "*/{xml,javascript,x-wine-extension-ini}";
              run = ''piper -- ${bat} "$1"'';
            }
            {
              url = "*.qcow2";
              run = ''piper -- ${qemu-img} info "$1" | ${bat} -l asa'';
            }
            {
              url = "*/";
              run = ''piper -- ${getExe eza} --color=always --icons=always --no-quotes -TL=3 -l --git --no-permissions --no-user --group-directories-first --no-filesize --no-time "$1"'';
            }
            {
              url = "*.txt.gz";
              run = ''piper -- ${getExe gzip} -dc "$1"'';
            }
            {
              mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
              run = "ouch --show-file-icons";
            }
          ];

        plugin.append_previewers = [
          {
            url = "*";
            run = ''piper -- ${getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
          }
        ];

        plugin.prepend_fetchers = [
          {
            group = "git";
            url = "*";
            run = "git";
          }
          {
            group = "git";
            url = "*/";
            run = "git";
          }
        ];
      };

      _file = ./plugins.nix;
    };
}
