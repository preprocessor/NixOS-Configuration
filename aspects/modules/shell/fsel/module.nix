{
  envoy.fsel.github = "Mjoyufull/fsel";

  perSystem =
    { pkgs, envoy, ... }:
    {
      packages.fsel = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        inherit (envoy.fsel) pname version src;
        cargoHash = "sha256-G1wfue1Q+3NMH/5NqPVKeO0NpU0WJlwWkh51r3TM5IM=";
      });
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

  w.desktop =
    { lib, config, ... }:
    {
      config = lib.mkIf (config.wrappers.fsel.enable) {
      };

      _file = ./module.nix;

    };
}
