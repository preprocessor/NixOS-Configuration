{
  exo.skeleton =
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
          default = wrapPackage (
            { wlib, ... }:
            {
              package = pkgs.starship;
              env.STARSHIP_CONFIG = "${wlib.files}/starship.toml";
              files =
                "starship.toml"
                |> wlib.buildAndAppend' {
                  formatter = toml;
                  buildFrom = cfg.settings;
                  appendString = cfg.moreCfg;
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
