{
  w.desktop =
    { lib, config, ... }:
    {
      custom.programs.vivaldi = {
        enable = true;
      };

      custom.programs.hyprland.startup =
        let
          cfg = config.custom.programs.vivaldi;
        in
        [ ''hl.exec_cmd("${lib.getExe cfg.package}", { workspace = 'name:web' })'' ];
    };

  w.default =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.custom.programs.vivaldi;
      yaml = pkgs.formats.yaml { };
    in
    {
      options.custom.programs.vivaldi = {
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
