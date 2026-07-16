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
              { wlib, ... }:
              {
                package = pkgs.mpv;
                files = {
                  "configuration/mpv.conf" = cfg.conf;
                  "configuration/input.conf" = cfg.input;
                  "configuration/scripts" = "${mpvScripts}/share/mpv/scripts";
                  "configuration/fonts" = "${mpvScripts}/share/fonts";
                  "configuration/script-opts/modernz.conf" = lib.generators.toKeyValue { } {
                    download_path = "${config.hj.directory}/Videos/mpv";
                    osc_on_start = "no";
                    osc_on_seek = "no";
                    showonpause = "no";
                  };
                };
                env.MPV_HOME = "${wlib.files}/configuration";
              }
            );
        };

        image-viewer = lib.mkOption {
          type = lib.types.package;
          default = wrapPackage {
            package = pkgs.mpv;
            files = {
              "configuration/mpv.conf" = cfg.image-conf;
              "configuration/input.conf" = cfg.image-input;
            };
          };
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
