{
  tack.fsel = {
    url = "gh:Mjoyufull/fsel";
    type = "fetch";
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.eza = pkgs.eza.overrideAttrs (o: {
        patches = (o.patches or [ ]) ++ [ ./custom-icons.patch ];
        doCheck = false;
      });
    };

  exo.skeleton =
    {
      wrapPackage,
      config,
      self',
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.eza;
      yaml = pkgs.formats.yaml { };
    in
    {
      options.my.eza = {
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
          default = wrapPackage (
            { wlib, ... }:
            {
              package = self'.packages.eza;
              env.EZA_CONFIG_DIR = wlib.files;
              files =
                "theme.yml"
                |> wlib.buildAndAppend' {
                  formatter = yaml;
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
