{
  exo.core = {
    my.atuin = {
      enable = true;
      settings = {
        enter_accept = true;
        filter_mode = "session-preload";
        search_mode = "fuzzy";
      };
    };
  };

  exo.skeleton =
    {
      birdee,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.atuin;
      toml = pkgs.formats.toml { };
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        programs.fish.interactiveShellInit = "${lib.getExe pkgs.atuin} init fish | source";
      };

      options.my.atuin = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into atuin's yaml config";
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
              package = pkgs.atuin;
              env.ATUIN_CONFIG_DIR = dirOf config.constructFiles.atuin-config.path;
              constructFiles.atuin-config = {
                relPath = "config.toml";
                builder = ''
                  install -m644 -DT "${toml.generate "config.toml" cfg.settings}" "$2"
                  echo -e "\n${cfg.moreCfg}" >> "$2"
                '';
              };
            }
          );
        };
      };
    };
}
