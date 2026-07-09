{
  w.default =
    {
      birdee,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.custom.programs.mpv;
    in
    {

      options.custom.programs.mpv = {
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
          default = birdee.wrappers.mpv.wrap {
            inherit pkgs;
            "mpv.conf".content = cfg.conf;
            "mpv.input".content = cfg.input;
            script = {
              mpris.path = pkgs.mpvScripts.mpris;
              modernz = {
                path = pkgs.mpvScripts.modernz;
                opts.download_path = "${config.hj.directory}/Videos/mpv";
                opts.osc_on_start = "no";
                opts.osc_on_seek = "no";
                opts.showonpause = "no";
              };
            };
          };
        };

        image-viewer = lib.mkOption {
          type = lib.types.package;
          default = birdee.wrappers.mpv.wrap {
            inherit pkgs;
            "mpv.conf".content = cfg.image-conf;
            "mpv.input".content = cfg.image-input;
          };
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = [
          cfg.package
          cfg.image-viewer
        ];

        custom.xdg.desktopEntries."umpv".noDisplay = true;

        custom.xdg.desktopEntries."mpvi" = {
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
