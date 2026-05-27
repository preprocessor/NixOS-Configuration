{
  envoy.fsel.github = "Mjoyufull/fsel";

  perSystem =
    { pkgs, ... }:
    {
      packages.eza = pkgs.eza.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [ ./custom-icons.patch ];
        doCheck = false;
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
      cfg = config.wrappers.eza;
      yaml = pkgs.formats.yaml { };
    in
    {
      options.wrappers.eza = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (yaml) type;
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
              package = self'.packages.eza;
              env.EZA_CONFIG_DIR = dirOf config.constructFiles.generatedConfig.path;
              constructFiles.generatedConfig = {
                relPath = "theme.yml";
                builder = ''
                  mkdir -p "$(dirname "$2")"
                  cat ${yaml.generate "theme.yaml" cfg.settings} > "$2"
                  printf '\n%s\n' "${cfg.moreCfg}" >> "$2"
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
