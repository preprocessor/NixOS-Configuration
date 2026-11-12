{
  flake.hjemModules.halloy =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.halloy;
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];
      };

      options.my.halloy = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          type = lib.types.toml;
          default = { };
          description = "Options to go into halloy's yaml config";
        };

        theme = lib.mkOption {
          type = lib.types.toml;
          default = { };
        };

        package = lib.mkPackageOption pkgs "halloy" { } // {
          default = wrapPackage (
            { wlib, ... }:
            {
              package = pkgs.halloy;
              env.XDG_CONFIG_HOME = wlib.out;
              files = {
                config = {
                  path = "halloy/config.toml";
                  file = wlib.toml "halloy-config" cfg.settings // {
                    settings.theme = "theme";
                  };
                };
                theme = {
                  path = "halloy/themes/theme.toml";
                  file = wlib.toml "halloy-theme" cfg.theme;
                };
              };
            }
          );
        };
      };
    };
}
