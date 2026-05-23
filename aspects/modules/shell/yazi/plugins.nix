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

      fuzzy-search = pkgs.yaziPlugins.mkYaziPlugin {
        inherit (envoy.fuzzy-search-src) pname version;

        src = lib.cleanSourceWith {
          inherit (envoy.fuzzy-search-src) src;
          filter = name: type: (baseNameOf name == "main.lua");
        };
      };

      zoom = envoy.yazi-plugins-repo.src + "/zoom.yazi";

      confirm-dialog = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "confirm-dialog";
        version = "1.0";
        src = pkgs.writeTextFile {
          name = "confirm-dialog-src";
          destination = "/main.lua";
          text = # lua
            ''
              --- @sync entry
              local function entry()
                  if not os.getenv("YAZI_CHOOSER_SAVE") then
                      return ya.emit("open", { hovered = true })
                  end

                  local h = cx.active.current.hovered
                  if not h then return end

                  if h.cha.is_dir then
                      return ya.emit("enter", {})
                  end

                  if h.cha.len ~= nil then
                      local yes = ya.confirm {
                          pos   = { "center", w = 62, h = 10 },
                          title = "Overwrite file?",
                          body  = ui.Text(
                              tostring(h.url) .. "\n\nThis file already exists and will be overwritten."
                          ):wrap(ui.Wrap.YES),
                      }
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
              run = ''piper -- ${getExe eza} --color=always --icons=always --no-quotes -TL=3 "$1"'';
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
            id = "git";
            url = "*";
            run = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
          }
        ];

      };
    };
}
