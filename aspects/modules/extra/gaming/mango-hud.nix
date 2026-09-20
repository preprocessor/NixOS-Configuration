{
  exo.mods.gaming = {
    my.mangohud = {
      enable = true;
      envConfig = true;

      settings = {
        position = "top-left";
        hud_compact = true;
        round_corners = 0;
        font_size = 17;

        background_alpha = 0;
        fps = true;
        frametime = true;
        fps_limit = "60+30+0"; # careful with the fps limiter, Dark Souls 2 SOFTS doesn't like it
        fps_limit_method = "early";
        toggle_fps_limit = "Alt_L+f";
        horizontal = true;

        cpu_stats = true;

        gpu_stats = true;

        ram = true;
        vram = true;

        toggle_hud = "Alt_L+m";
      };
    };
  };

  exo.skeleton =
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
      options = {
        my.mangohud = {
          enable = lib.mkEnableOption "Mangohud";

          envConfig = lib.mkEnableOption "MANGOHUD_CONFIG environment variable generation";

          package = lib.mkPackageOption pkgs "mangohud" { };

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
    };
}
