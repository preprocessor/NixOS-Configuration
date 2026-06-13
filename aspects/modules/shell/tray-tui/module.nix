{ ... }@top:
{
  ff.tray-tui.url = "github:Levizor/tray-tui";

  w.default =
    {
      birdee,
      config,
      inputs',
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.wrappers.tray-tui;
      toml = pkgs.formats.toml { };
    in
    {
      options.wrappers.tray-tui = {
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
          default = birdee.lib.wrapPackage (
            { config, ... }:
            {
              inherit pkgs;
              package = inputs'.tray-tui.packages.tray-tui;
              flags = {
                "--config-path" = config.constructFiles.generatedConfig.path;
              };
              constructFiles.generatedConfig = {
                relPath = "config.toml";
                content = (cfg.settings |> toml.generate "config.toml" |> builtins.readFile) + cfg.moreCfg;
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
