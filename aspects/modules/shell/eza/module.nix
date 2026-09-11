{
  perSystem =
    { pkgs, ... }:
    {
      remotePackages.eza = pkgs.eza.overrideAttrs (o: {
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

        package = lib.mkOption {
          default = wrapPackage (
            { files, wlib, ... }:
            {
              package = self'.packages.eza;
              env.EZA_CONFIG_DIR = files.theme.dir;
              files.theme = {
                relPath = "config/theme.yml";
                file = wlib.yaml "theme.yml" cfg.settings;
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
