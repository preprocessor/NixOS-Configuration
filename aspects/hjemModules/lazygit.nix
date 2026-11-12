{
  flake.hjemModules.lazygit =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.lazygit;
      yaml = pkgs.formats.yaml { };
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        programs.fish.shellFunctions.lg = {
          modifiers.wraps = "lazygit";
          body = /* fish */ ''
            set -x LAZYGIT_NEW_DIR_FILE ${config.hj.xdg.config.directory}/lazygit/newdir
            command lazygit $argv
            if test -f $LAZYGIT_NEW_DIR_FILE
              cd (cat $LAZYGIT_NEW_DIR_FILE)
              rm -f $LAZYGIT_NEW_DIR_FILE
            end
          '';
        };
      };

      options.my.lazygit = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "lazygit" { } // {
          default = wrapPackage (
            { files, wlib, ... }:
            {
              package = pkgs.lazygit;
              env.LG_CONFIG_FILE = files.config;
              files.config = {
                path = "config/config.yml";
                file = wlib.yaml "config.yml" config.my.lazygit.settings;
              };
            }
          );
        };

        settings = lib.mkOption {
          inherit (yaml) type;
          default = { };
          description = "Options to go into lazygit's yaml config";
        };
      };
    };
}
