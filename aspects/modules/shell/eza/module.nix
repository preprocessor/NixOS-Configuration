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
      cfg = config.custom.programs.eza;
      yaml = pkgs.formats.yaml { };
    in
    {
      options.custom.programs.eza = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (yaml) type;
          default = { };
          description = "Options to go into eza's yaml config";
        };

        moreCfg = lib.mkOption {
          type = with lib.types; nullOr (either path lines);
          default = "";
          description = "Additional config lines.";
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
                  install -m655 -DT "${yaml.generate "theme.yml" cfg.settings}" "$2"
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
