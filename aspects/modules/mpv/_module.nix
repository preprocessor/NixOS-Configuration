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
      cfg = config.wrappers.mpv;
    in
    {

      options.wrappers.mpv = {
        enable = lib.mkEnableOption "mpv";

        with-wlpaste = lib.mkEnableOption "mpv-wl-paste";

        conf = lib.mkOption {
          default = "";
          type = lib.types.lines;
        };

        input = lib.mkOption {
          default = "";
          type = lib.types.lines;
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = birdee.wrappers.mpv.wrap {
            inherit pkgs;
            package = pkgs.mpv;
            "mpv.conf".content = cfg.conf;
            "mpv.input".content = cfg.input;
            script = {
              mpris.path = pkgs.mpvScripts.mpris;
              sponsorblock.path = pkgs.mpvScripts.sponsorblock;
              dynamic-crop.path = pkgs.mpvScripts.dynamic-crop;
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

        mpv-wlpaste = lib.mkOption {
          type = lib.types.package;
          default = pkgs.writeShellApplication {
            name = "mpv-wlpaste";
            runtimeInputs = with pkgs; [
              cfg.package
              wl-clipboard
              uutils-coreutils-noprefix
            ];
            text = ''
              url=$(wl-paste | tr -d '[:space:]')
              if [ -z "$url" ]; then
                exit 0
              fi
              case "$url" in
                *tiktok.com*)
                  url="''${url%%\?*}"
                  ;;
              esac
              exec mpv "$url"
            '';
          };
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        wrappers.otter-launcher.modules = lib.mkIf cfg.with-wlpaste [
          {
            description = "video";
            prefix = "mpv";
            cmd = "niri msg action spawn -- ${cfg.mpv-wlpaste}/bin/mpv-wlpaste";
          }
        ];
      };

      _file = ./module.nix;
    };

}
