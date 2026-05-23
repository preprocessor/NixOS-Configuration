{ ... }@top:
let
  resize = top.config.utils.otterResize;
in
{
  w.default =
    {
      birdee,
      config,
      self',
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.wrappers.fsel;
      toml = pkgs.formats.toml { };
    in
    {
      options.wrappers.fsel = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into fsel's toml config";
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
              package = self'.packages.fsel;
              extraPackages = with pkgs; [
                pulsemixer
                fetchutils
                xrandr
                chafa
              ];
              flags = {
                "--config" = config.constructFiles.generatedConfig.path;
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

        otter-launcher.settings.modules = [
          {
            cmd = resize 500 1000 ''fsel -d -r -ss "{}"'';
            description = "search apps";
            prefix = "find";
            with_argument = true;
          }

          {
            cmd = resize 500 1000 ''fsel -d -r -p "{}"'';
            description = "launch apps";
            prefix = "app";
            with_argument = true;
          }
        ];
      };

      _file = ./module.nix;
    };

  w.desktop =
    { lib, config, ... }:
    {
      config = lib.mkIf (config.wrappers.fsel.enable) {
        wrappers.otter-launcher.settings.modules = [
          {
            cmd = resize 500 1000 ''fsel -d -r -ss "{}"'';
            description = "search apps";
            prefix = "find";
            with_argument = true;
          }

          {
            cmd = resize 500 1000 ''fsel -d -r -p "{}"'';
            description = "launch apps";
            prefix = "app";
            with_argument = true;
          }
        ];
      };

    };
}
