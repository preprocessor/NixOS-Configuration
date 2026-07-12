{
  w.desktop =
    { lib, config, ... }:
    {
      my.vivaldi = {
        enable = true;
      };

      my.hyprland.startup =
        let
          cfg = config.my.vivaldi;
        in
        [ ''hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "name:web silent" })'' ];

      hj.xdg.mime-apps.default-applications =
        [
          "text/html"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/about"
          "x-scheme-handler/unknown"
        ]
        |> map (mime: lib.nameValuePair mime [ "vivaldi-stable.desktop" ])
        |> lib.listToAttrs;
    };

  w.default =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.vivaldi;
      yaml = pkgs.formats.yaml { };
    in
    {
      options.my.vivaldi = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (yaml) type;
          default = { };
          description = "Options to go into vivaldi's config";
        };

        moreCfg = lib.mkOption {
          type = with lib.types; nullOr (either path lines);
          default = "";
          description = "Additional config lines.";
        };

        package = lib.mkPackageOption pkgs "vivaldi" { };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];
      };
    };
}
