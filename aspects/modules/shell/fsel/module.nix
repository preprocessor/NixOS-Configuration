{ inputs, ... }:
{
  tack.fsel = {
    url = "gh:Mjoyufull/fsel";
    type = "fetch";
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.fsel = pkgs.rustPlatform.buildRustPackage {
        src = inputs.fsel;
        pname = "fsel";
        version = "git";
        cargoHash = "sha256-SAQnY0VgRPLjkjmEgZcyjp6hFXxp54PB1j52qwAy9yI=";
      };
    };

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
      cfg = config.my.fsel;
      toml = pkgs.formats.toml { };
    in
    {
      options.my.fsel = {
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
              flags = {
                "--config" = config.constructFiles.generatedConfig.path;
              };
              constructFiles.generatedConfig = {
                relPath = "config.toml";
                builder = ''
                  install -m655 -DT "${toml.generate "config.toml" cfg.settings}" "$2"
                  echo -e "\n${cfg.moreCfg}" >> "$2"
                '';
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
