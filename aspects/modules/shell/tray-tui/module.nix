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
            { files, wlib, ... }:
            {
              package = pkgs.tray-tui;
              args = [
                ''--config-path "${files.config}"''
              ];
              files.config = {
                relPath = "config/config.toml";
                file = wlib.toml "config.toml" cfg.settings;
              };
            }
          );
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];

        my.xdg.desktopTuiEntries."Tray TUI" = {
          package = config.my.tray-tui.package;
          width = 1200;
          height = 1200;
        };
      };

      _file = ./module.nix;
    };
}
