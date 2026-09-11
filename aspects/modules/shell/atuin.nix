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
      wrapPackage,
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

        package = lib.mkOption {
          default = wrapPackage (
            { files, wlib, ... }:
            {
              package = pkgs.atuin;
              env.ATUIN_CONFIG_DIR = files.config.dir;
              files.config = {
                relPath = "config/config.toml";
                file = wlib.toml "config.toml" cfg.settings;
              };
            }
          );
        };
      };
    };
}
