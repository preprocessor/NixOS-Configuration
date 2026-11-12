{
  flake.hjemModules.lla =
    {
      wrapPackage,
      config,
      self',
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.lla;
    in
    {
      options.my.lla = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          type = lib.types.toml;
          default = { };
          description = "Options to go into halloy's yaml config";
        };

        package = lib.mkPackageOption pkgs "lla" { } // {
          default = wrapPackage (
            { wlib, ... }: {
              package = self'.packages.lla;
              env.XDG_CONFIG_HOME = wlib.out;
              files.config = {
                path = "lla/config.toml";
                file = wlib.toml "lla-config" cfg.settings;
              };
            }
          );
        };
      };

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          { hj.packages = [ cfg.package ]; }

          (lib.mkIf config.programs.fish.enable {
            programs.fish.shellFunctions = {
              ls.body = "${lib.getExe cfg.package}";
              l.body = "${lib.getExe cfg.package} -T";
              la.body = "${lib.getExe cfg.package} -AT";
              ll.body = "${lib.getExe cfg.package} -Al";
              lss.body = "${lib.getExe cfg.package} -s";
            };
          })
        ]
      );
    };
}
