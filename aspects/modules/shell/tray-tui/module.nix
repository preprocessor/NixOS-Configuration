{
  exo.skeleton =
    {
      config,
      pkgs,
      wrapPackage,
      lib,
      ...
    }:
    let
      cfg = config.my.tray-tui;
      toml = pkgs.formats.toml { };
    in
    {
      options.my.tray-tui = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into tray-tui's toml config";
        };

        moreCfg = lib.mkOption {
          type = with lib.types; nullOr (either path lines);
          default = "";
          description = "Additional config lines.";
          example = lib.literalExpression "./config.toml";
        };

        package = lib.mkOption {
          default = wrapPackage (
            { wlib, ... }:
            {
              package = pkgs.tray-tui;
              args = [
                ''--config-path "${wlib.files}"''
              ];
              files =
                "config.toml"
                |> wlib.buildAndAppend' {
                  formatter = toml;
                  buildFrom = cfg.settings;
                  appendString = cfg.moreCfg;
                };
            }
          );
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];
      };

      _file = ./module.nix;
    };
}
