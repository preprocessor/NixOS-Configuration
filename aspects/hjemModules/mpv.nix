{
  flake.hjemModules.mpv =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      mkConf = lib.concatMapAttrsStringSep "\n" (
        name: value: "${name}=${value |> (if lib.isBool value then lib.boolToYesNo else toString)}"
      );

      mkInput = lib.concatMapAttrsStringSep "\n" (
        name: value:
        if lib.isList value then
          value |> lib.concatMapStringsSep "\n" (v: "${name} ${v}")
        else
          "${name} ${value}"
      );

      cfg = config.my.mpv;
      cfgi = config.my.mpvi;
    in
    {
      options.my = {
        mpv = {
          enable = lib.mkEnableOption "mpv";

          conf = lib.mkOption {
            default = { };
            type =
              with lib.types;
              attrsOf (oneOf [
                str
                bool
                int
                float
              ]);
          };

          input = lib.mkOption {
            default = { };
            type = with lib.types; attrsOf (either str (listOf str));
          };

          package = lib.mkOption {
            type = lib.types.package;
            default = wrapPackage (
              { files, ... }:
              {
                package = pkgs.mpv;
                env.MPV_HOME = files.mpv.dir;
                files = {
                  mpv = {
                    path = "config/mpv.conf";
                    file = "${mkConf cfg.conf}";
                  };
                  input = {
                    path = "config/input.conf";
                    file = "${mkInput cfg.input}";
                  };
                  scripts = {
                    path = "config/scripts";
                    file = "${
                      pkgs.symlinkJoin {
                        name = "mpv-scripts";
                        paths = with pkgs.mpvScripts; [
                          mpris
                          sponsorblock
                          modernz
                        ];
                      }
                    }/share/mpv/scripts";
                  };
                  fonts = {
                    path = "config/fonts";
                    file = "${pkgs.mpvScripts.modernz}/share/fonts/truetype";
                  };
                  modernz = {
                    path = "config/script-opts/modernz.conf";
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
        };

        mpvi = {
          enable = lib.mkEnableOption "mpvi";

          conf = lib.mkOption {
            default = { };
            type =
              with lib.types;
              attrsOf (oneOf [
                str
                bool
                int
                float
              ]);
          };

          input = lib.mkOption {
            default = { };
            type = with lib.types; attrsOf str;
          };

          package = lib.mkOption {
            type = lib.types.package;
            default = wrapPackage (
              { files, ... }:
              {
                package = pkgs.mpv;
                env.MPV_HOME = files.mpv.dir;
                files = {
                  mpv = {
                    path = "config/mpv.conf";
                    file = "${mkConf cfgi.conf}";
                  };
                  input = {
                    path = "config/input.conf";
                    file = "${mkInput cfgi.input}";
                  };
                };
              }
            );
          };
        };
      };

      config = lib.mkMerge [
        (lib.mkIf cfg.enable {
          hj.packages = [ cfg.package ];

          my.xdg.desktopEntries."umpv".noDisplay = true;

          hj.xdg.mime-apps.default-applications =
            [
              "audio/aac"
              "audio/mpeg"
              "audio/ogg"
              "audio/opus"
              "audio/wav"
              "audio/webm"
              "audio/x-matroska"
              "video/mp2t"
              "video/mp4"
              "video/mpeg"
              "video/ogg"
              "video/webm"
              "video/x-flv"
              "video/x-matroska"
              "video/x-msvideo"
            ]
            |> map (mime: lib.nameValuePair mime [ "mpv.desktop" ])
            |> lib.listToAttrs;

          my.hyprland.windowrules.mpv = [
            {
              name = "mpv";
              match.class = "mpv";
              rules = {
                center = true;
                float = true;
              };
            }
          ];
        })

        (lib.mkIf cfgi.enable {
          hj.packages = [ cfgi.package ];

          hj.xdg.mime-apps.default-applications =
            [
              "image/bmp"
              "image/gif"
              "image/jpeg"
              "image/jpg"
              "image/png"
              "image/tiff"
              "image/vnd.microsoft.icon"
              "image/webp"
            ]
            |> map (mime: lib.nameValuePair mime [ "mpvi.desktop" ])
            |> lib.listToAttrs;

          my.xdg.desktopEntries."mpvi" = {
            name = "MPV Image Viewer";
            exec = "${cfgi.package}/bin/mpv %U";
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
        })
      ];
    };
}
