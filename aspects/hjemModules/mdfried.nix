{
  flake.hjemModules.mdfried =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.mdfried;
    in
    {
      options.my.mdfried = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "mdfried" { } // {
          default = wrapPackage (
            { wlib, ... }: {
              package = pkgs.mdfried;
              env.XDG_CONFIG_HOME = wlib.out;
              files.config = {
                path = "mdfried/config.toml";
                file = wlib.toml "mdfried-config" cfg.settings;
              };
            }
          );
        };

        settings = lib.mkOption {
          type = lib.types.toml;
          default = { };
          description = "Options to go into mdfried's toml config";
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];
      };
    };
}
