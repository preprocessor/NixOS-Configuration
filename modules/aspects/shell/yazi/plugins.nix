{ inputs, lib, ... }:
{
  flake-file.inputs = {
    yazi-plugin-fuzzy-search.url = "github:onelocked/fuzzy-search.yazi";
    yazi-plugins-repo = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
  };

  flake.modules.homeManager.default =
    { pkgs, ... }:
    let
      zoom = inputs.yazi-plugins-repo + "/zoom.yazi";
      inherit (lib) getExe;
    in
    {
      imports = [ inputs.yazi-plugin-fuzzy-search.homeManagerModules.default ];

      home.packages = [ pkgs.ouch ];

      programs.yazi = {
        plugins = {
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
            piper
            chmod
            ;
          inherit zoom;
        };

        initLua = /* lua */ ''
          require("starship"):setup()

          require("git"):setup {
          	order = 1500, -- Order of status signs showing in the line mode
          }

          require("smart-enter"):setup {
            open_multi = true, -- Allow open to target multiple selected files
          }
        '';

        yaziPlugins = {
          plugins = {
            # hide-preview.enable = true;
            fuzzy-search = {
              enable = true;
              enableFishIntegration = true;
              depth = 3;
              keymaps = {
                fd = true;
                rg = true;
                zoxide = true;
              };
            };
          };
        };

        keymap = {
          mgr.prepend_keymap = [
            {
              on = "+";
              run = "plugin zoom 1";
              desc = "Zoom in hovered file";
            }
            {
              on = "-";
              run = "plugin zoom -1";
              desc = "Zoom out hovered file";
            }
            {
              on = [ "<C-d>" ];
              run = "plugin drag";
              desc = "Drag Files";
            }
            {
              on = [ "h" ];
              run = "plugin bypass reverse";
              desc = "Enter the child directory, or open the file";
            }
            {
              on = [ "l" ];
              run = "plugin bypass smart-enter";
              desc = "Enter the child directory, or open the file";
            }
            {
              on = "f";
              run = "plugin smart-filter";
              desc = "Smart filter";
            }
            {
              on = "F";
              run = "plugin jump-to-char";
              desc = "Jump to char";
            }
            {
              on = [ "C" ];
              run = "plugin ouch";
              desc = "Compress with ouch";
            }
            {
              on = "u";
              run = "plugin restore";
              desc = "Restore last deleted files/folders";
            }
            {
              on = [ "U" ];
              run = "plugin restore -- --interactive";
              desc = "Restore deleted files/folders (Interactive)";
            }
            {
              on = [
                "c"
                "m"
              ];
              run = "plugin chmod";
              desc = "Chmod on selected files";
            }
            {
              on = [
                "g"
                "l"
              ];
              run = "plugin lazygit";
              desc = "Open lazygit";
            }
          ];
        };

        settings.plugin = {
          prepend_previewers =
            let
              bat = "${getExe pkgs.bat} -p --color=always";
              qemu-img = lib.getExe' pkgs.qemu-utils "qemu-img";
            in
            [
              {
                url = "*.md";
                run = ''piper -- CLICOLOR_FORCE=1 ${getExe pkgs.glow} -w=$w -s=dark -- "$1"'';
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
                run = ''piper -- ${getExe pkgs.eza} --color=always --icons=always --no-quotes -TL=3 "$1"'';
              }
              {
                url = "*.txt.gz";
                run = ''piper -- ${getExe pkgs.gzip} -dc "$1"'';
              }
              {
                mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
                run = "ouch --show-file-icons";
              }
            ];

          append_previewers = [
            {
              url = "*";
              run = ''piper -- ${getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
            }
          ];

          prepend_fetchers = [
            # fix git.yazi.nix's broken defaults
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

          prepend_keymap = [
            {
              on = "<A-Up>";
              run = "seek -1";
              desc = "Scroll up";
            }
            {
              on = "<A-Down>";
              run = "seek +1";
              desc = "Scroll down";
            }
            {
              on = "<A-PageUp>";
              run = "seek -15";
              desc = "Scroll page up";
            }
            {
              on = "<A-PageDown>";
              run = "seek +15";
              desc = "Scroll page down";
            }
            {
              on = "<A-Home>";
              run = "seek -10000";
              desc = "Scroll to the top";
            }
            {
              on = "<A-End>";
              run = "seek +10000";
              desc = "Scroll to the bottom";
            }
          ];
        };
      };
    };
}
