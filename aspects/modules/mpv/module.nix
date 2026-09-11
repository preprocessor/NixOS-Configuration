{
  exo.skeleton =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.mpv;
    in
    {

      options.my.mpv = {
        enable = lib.mkEnableOption "mpv";

        conf = lib.mkOption {
          default = "";
          type = lib.types.lines;
        };

        input = lib.mkOption {
          default = "";
          type = lib.types.lines;
        };

        image-conf = lib.mkOption {
          default = "";
          type = lib.types.lines;
        };

        image-input = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default =
            let
              mpvScripts = pkgs.symlinkJoin {
                name = "mpv-scripts";
                paths = with pkgs.mpvScripts; [
                  mpris
                  sponsorblock
                  modernz
                ];
              };
            in
            wrapPackage (
              { files, ... }:
              {
                package = pkgs.mpv;
                env.MPV_HOME = files.mpv.dir;
                files = {
                  mpv = {
                    relPath = "config/mpv.conf";
                    file = cfg.conf;
                  };
                  input = {
                    relPath = "config/input.conf";
                    file = cfg.input;
                  };
                  scripts = {
                    relPath = "config/scripts";
                    file = "${mpvScripts}/share/mpv/scripts";
                  };
                  fonts = {
                    relPath = "config/fonts";
                    file = "${pkgs.mpvScripts.modernz}/share/fonts/truetype";
                  };
                  modernz = {
                    relPath = "config/script-opts/modernz.conf";
                    file = lib.generators.toKeyValue { } {
                      download_path = "${config.hj.directory}/Videos/mpv";
                      osc_on_start = "no";
                      osc_on_seek = "no";
                      showonpause = "no";
                    };
                  };
                };
              }
            );
        };

        image-viewer = lib.mkOption {
          type = lib.types.package;
          default = wrapPackage (
            { files, ... }:
            {
              package = pkgs.mpv;
              env.MPV_HOME = files.mpv.dir;
              files = {
                mpv = {
                  relPath = "config/mpv.conf";
                  file = cfg.image-conf;
                };
                input = {
                  relPath = "configuration/input.conf";
                  file = cfg.image-input;
                };
              };
            }
          );
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = [
          cfg.package
          cfg.image-viewer
        ];

        my.xdg.desktopEntries."umpv".noDisplay = true;

        my.xdg.desktopEntries."mpvi" = {
          name = "MPV Image Viewer";
          exec = "${cfg.image-viewer}/bin/mpv %U";
          noDisplay = true;
          icon = "mpv";
          mimeType = [
            "image/png"
            "image/jpeg"
            "image/jpg"
            "image/webp"
            "image/gif"
          ];
        };
      };

      _file = ./module.nix;
    };

}
