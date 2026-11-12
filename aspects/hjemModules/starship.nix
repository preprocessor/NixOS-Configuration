{
  flake.hjemModules.starship =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.starship;
      toml = pkgs.formats.toml { };
    in
    {
      options.my.starship = {
        enable = lib.mkEnableOption { };
        enableFishIntegration = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "starship" { } // {

          default = wrapPackage (
            { files, wlib, ... }:
            {
              package = pkgs.starship;
              env.STARSHIP_CONFIG = files.config;
              files.config = {
                path = "config/starship.toml";
                file = wlib.toml "starship.toml" config.my.starship.settings;
              };
            }
          );
        };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into starship's toml config";
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];

        programs.fish.interactiveShellInit = lib.mkIf (cfg.enableFishIntegration) ''
          if test "$TERM" != "dumb"
            ${lib.getExe cfg.package} init fish | source
            enable_transience
          end
        '';
      };
    };
}
