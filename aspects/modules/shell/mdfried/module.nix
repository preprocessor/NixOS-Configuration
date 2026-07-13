{
  exo.skeleton =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.mdfried;
      toml = pkgs.formats.toml { };
    in
    {
      options.my.mdfried = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "mdfried" { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into mdfried's toml config";
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];

        hj.xdg.config.files."mdfried/config.toml".source = toml.generate "mdfried-config" cfg.settings;
      };

      _file = ./module.nix;
    };

}
