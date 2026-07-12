{
  w.default =
    {
      config,
      pkgs,
      lib,
      birdee,
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

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into starship's toml config";
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
              package = pkgs.starship;
              env.STARSHIP_CONFIG = config.constructFiles.generatedConfig.path;
              constructFiles.generatedConfig = {
                relPath = "starship.toml";
                builder = ''
                  install -m655 -DT "${toml.generate "starship.toml" cfg.settings}" "$2"
                  echo -e "\n${cfg.moreCfg}" >> "$2"
                '';
              };
            }
          );
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
