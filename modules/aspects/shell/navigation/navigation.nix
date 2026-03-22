{ lib, inputs, ... }:
{
  flake-file.inputs = {
    awww.url = "git+https://codeberg.org/LGFae/awww";
    nix-yazi-plugins.url = "github:lordkekz/nix-yazi-plugins";
    yazi-plugin-faster-piper = {
      url = "github:alberti42/faster-piper.yazi";
      flake = false;
    };
  };

  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      imports = [
        (inputs.nix-yazi-plugins.legacyPackages.x86_64-linux.homeManagerModules.default)
      ];

      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };

      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
        enableBashIntegration = true;
        enableFishIntegration = true;

        plugins = with pkgs.yaziPlugins; {
          faster-piper = inputs.yazi-plugin-faster-piper;
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
            recycle-bin.enable = true;
          };
        };

        settings.open = {
          prepend_rules = [
            {
              mime = "image/*"; # Apply this to all image types
              use = [
                "open"
                "setwallpaper"
                "gimp"
              ];
            }
            {
              mime = "video/*"; # Apply this to all video types
              use = [
                "open"
                "setwallpaper"
              ];
            }
          ];
        };

        settings.opener =
          let
            awww = lib.getExe inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww;
          in
          {
            setwallpaper = [
              {
                run = "${awww} img --transition-fps 75 %s";
                desc = "Set Wallpaper";
              }
            ];
            gimp = [
              {
                run = "gimp %s";
                desc = "Image Editor";
              }
            ];
            video-trimmer = [
              {
                run = "${lib.getExe pkgs.video-trimmer} %s";
                desc = "Video Trimmer";
              }
            ];
          };

        settings.preview = {
          wrap = "no";
          tab_size = 2;
          image_filter = "triangle"; # from fast to slow but high quality: nearest, triangle, catmull-rom, lanczos3
          cache_dir = "";
          image_delay = 0;
          max_width = 1926;
          max_height = 1366;
          image_quality = 90;
        };
        # settings.tasks = {
        #   micro_workers = 10;
        #   macro_workers = 10;
        #   bizarre_retry = 3;
        #   image_alloc = 536870912;
        #   image_bound = [
        #     0
        #     0
        #   ];
        #   suppress_preload = true;
        # };

        settings.mgr = {
          ratio = [
            1
            2
            4
          ];
        };

        settings.plugin =
          let
            eza = lib.getExe pkgs.eza;
          in
          {

            prepend_previewers = [
              {
                url = "*/";
                run = ''faster-piper -- ${eza} -TL=5 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
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
                run = ''faster-piper -- ${eza} -TL=5 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
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
            {
              on = [
                "g"
                "m"
              ];
              run = "cd /run/media/wyspr/";
              desc = "Go to Media";
            }
            {
              on = [
                "g"
                "l"
              ];
              run = "plugin lazygit";
              desc = "Open lazygit";
            }
            {
              on = [
                "g"
                "r"
              ];
              run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
              desc = "Go to git root";
            }
            {
              on = [
                "g"
                "n"
              ];
              run = "cd /home/wyspr/Configuration/NixOS/";
              desc = "Go to NixOS Configuration";
            }
            {
              on = [
                "b"
                "y"
              ];
              run = [
                ''shell -- for path in %s; do echo "file://$path"; done | wl-copy -t text/uri-list''
              ];
              desc = "Copy to clipboard";
            }
          ];
        };
      };
    };
}
