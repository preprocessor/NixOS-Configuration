{
  flake.hjemModules.btop =
    {
      wrapPackage,
      config,
      self',
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.btop;
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        my.xdg.desktopTuiEntries."btop" = {
          package = cfg.package;
          width = 2100;
          height = 1200;
        };

        # Enable monitoring of GPU wattage by programs like btop
        systemd.tmpfiles.rules = [
          "Z /sys/class/powercap/intel-rapl:0/energy_uj 0444 root root - -"
        ];
      };

      options.my.btop = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "btop" { } // {
          default = wrapPackage (
            { files, wlib, ... }:
            {
              package = self'.packages.btop;
              args = [
                "--config ${files.config}"
                "--themes-dir ${wlib.out}/config/themes"
              ];
              files = lib.mkMerge [
                {
                  config = {
                    path = "config/btop.conf";
                    file = lib.generators.toKeyValue {
                      mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
                    } cfg.settings;
                  };
                }
                (
                  lib.optionalAttrs (cfg.themes != { }) cfg.themes
                  |> lib.mapAttrs (
                    name: file: {
                      path = "config/themes/${name}.theme";
                      inherit file;
                    }
                  )
                )
              ];
            }
          );
        };

        settings = lib.mkOption {
          type = with lib.types; attrsOf (either bool str);
          default = { };
          description = "Key/value pairs written into `btop.conf`.";
        };

        themes = lib.mkOption {
          type = with lib.types; attrsOf (either path str);
          default = { };
          description = "Key/value pairs written into `btop.conf`.";
        };
      };
    };
}
