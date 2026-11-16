{
  modules.core = 
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkIf mkOption types;

      cfg = config.my.mangohud;

      settingsType =
        with types;
        (oneOf [
          bool
          int
          float
          str
          path
          (listOf (oneOf [
            int
            str
          ]))
        ]);

      renderOption =
        option:
        rec {
          int = toString option;
          float = int;
          path = int;
          bool = "0";
          string = option;
          list = lib.concatStringsSep "," (lib.lists.forEach option toString);
        }
        .${builtins.typeOf option};

      renderFormat =
        sep: suffix: attrs:
        attrs
        |> lib.mapAttrsToList (k: v: if lib.isBool v && v then k else "${k}=${renderOption v}")
        |> lib.concatStringsSep sep
        |> (str: str + suffix);

      renderSettings = renderFormat "\n" "\n";
      renderEnvString = renderFormat "," "";

    in
    {
      config = mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        hj.environment.sessionVariables = lib.mkMerge [
          (mkIf cfg.enableSessionWide {
            MANGOHUD = 1;
            MANGOHUD_DLSYM = 1;
          })
          (mkIf (cfg.envConfig && cfg.settings != { }) {
            MANGOHUD_CONFIG = renderEnvString cfg.settings;
          })
        ];

        hj.xdg.config.files = {
          "MangoHud/MangoHud.conf" = mkIf (cfg.settings != { }) { text = renderSettings cfg.settings; };
        }
        // lib.mapAttrs' (
          n: v: lib.nameValuePair "MangoHud/${n}.conf" { text = renderSettings v; }
        ) cfg.settingsPerApplication;
      };

      options.my.mangohud = {
        enable = lib.mkEnableOption "Mangohud";

        package = lib.mkPackageOption pkgs "mangohud" { };

        envConfig = lib.mkEnableOption "MANGOHUD_CONFIG environment variable generation";

        enableSessionWide = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Sets environment variables so that
            MangoHud is started on any application that supports it.
          '';
        };

        settings = mkOption {
          type = with types; attrsOf settingsType;
          default = { };
          example = lib.literalExpression ''
            {
              output_folder = ~/Documents/mangohud/;
              full = true;
            }
          '';
          description = ''
            Configuration written to
            {file}`$XDG_CONFIG_HOME/MangoHud/MangoHud.conf`. See
            <https://github.com/flightlessmango/MangoHud/blob/master/data/MangoHud.conf>
            for the default configuration.
          '';
        };

        settingsPerApplication = mkOption {
          type = with types; attrsOf (attrsOf settingsType);
          default = { };
          example = {
            mpv = {
              no_display = true;
            };
          };
          description = ''
            Sets MangoHud settings per application.
            Configuration written to
            {file}`$XDG_CONFIG_HOME/MangoHud/{application_name}.conf`. See
            <https://github.com/flightlessmango/MangoHud/blob/master/data/MangoHud.conf>
            for the default configuration.
          '';
        };
      };
    };
}
