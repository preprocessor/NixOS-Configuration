{ inputs, lib, ... }:
{
  flake-file.inputs = {
    nix-yazi-plugins.url = "github:lordkekz/nix-yazi-plugins";
    yazi-plugin-fuzzy-search.url = "github:onelocked/fuzzy-search.yazi";
    yazi-plugin-faster-piper = {
      url = "github:alberti42/faster-piper.yazi";
      flake = false;
    };
  };

  flake.modules.homeManager.default =
    { pkgs, ... }:

    let
      faster-piper = inputs.yazi-plugin-faster-piper;
      fuzzy-search = inputs.yazi-plugin-fuzzy-search.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      imports = [
        inputs.nix-yazi-plugins.legacyPackages.x86_64-linux.homeManagerModules.default
        inputs.yazi-plugin-fuzzy-search.homeManagerModules.default
      ];

      programs.yazi = {
        plugins = with pkgs.yaziPlugins; {
          inherit faster-piper;
          inherit fuzzy-search;
          inherit lazygit;
          inherit drag;
        };

        yaziPlugins = {
          enable = true;
          plugins = {
            bypass.enable = true;
            git.enable = true;
            jump-to-char = {
              enable = true;
              keys.toggle.on = [ "F" ];
            };
            hide-preview.enable = true;
            relative-motions = {
              enable = true;
              show_motion = true;
            };
            smart-enter.enable = true;
            smart-filter.enable = true;
            starship.enable = true;
            ouch.previewers.enable = true;
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
            # recycle-bin.enable = true;
          };
        };

        keymap = {
          mgr.prepend_keymap = [
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
          ];
        };

        settings.plugin = {
          prepend_previewers = [
            {
              url = "*/";
              run = ''faster-piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
            }
            {
              url = "*.md";
              run = "faster-piper --rely-on-preloader";
            }
            {
              url = "*.csv";
              run = "faster-piper --rely-on-preloader";
            }
            {
              url = "*.tar*";
              run = "faster-piper --rely-on-preloader --format=url";
            }
            {
              url = "*.txt.gz";
              run = "faster-piper --rely-on-preloader";
            }
          ];

          prepend_preloaders = [
            {
              url = "*/";
              run = ''faster-piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
            }
            {
              url = "*.md";
              run = ''faster-piper -- CLICOLOR_FORCE=1 ${lib.getExe pkgs.glow} -w=$w -s=dark -- "$1"'';
            }
            {
              url = "*.csv";
              run = ''faster-piper -- bat -p --color=always "$1"'';
            }
            {
              url = "*.tar*";
              run = ''faster-piper -- tar tf "$1"'';
            }
            {
              url = "*.txt.gz";
              run = ''faster-piper -- gzip -dc "$1"'';
            }
            {
              mime = "text/*";
              run = ''faster-piper -- bat -p "$1"'';
            }
            {
              mime = "*/xml";
              run = ''faster-piper -- bat -p "$1"'';
            }
            {
              mime = "*/javascript";
              run = ''faster-piper -- bat -p "$1"'';
            }
            {
              mime = "*/x-wine-extension-ini";
              run = ''faster-piper -- bat -p "$1"'';
            }
            {
              url = "justfile";
              run = ''faster-piper -- bat -p "$1" -l Make'';
            }
            {
              mime = "application/x-qemu-disk";
              run = ''faster-piper -- ${pkgs.qemu-utils}/bin/qemu-img info "$1"'';
            }
            {
              mime = "application/x-pie-executable";
              run = ''faster-piper -- ${lib.getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
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
