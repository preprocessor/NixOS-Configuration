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
      cfg = config.my.halloy;
      toml = pkgs.formats.toml { };
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];
      };

      options.my.halloy = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into halloy's yaml config";
        };

        theme = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Additional config lines.";
        };

        package = lib.mkOption {
          default = wrapPackage (
            { wlib, ... }:
            {
              package = pkgs.halloy;
              env.XDG_CONFIG_HOME = wlib.files;
              files = {
                "halloy/config.toml" = toml.generate "halloy-config" cfg.settings // {
                  settings.theme = "theme";
                };
                "halloy/themes/theme.toml" = toml.generate "halloy-theme" cfg.theme;
              };
            }
          );
        };
      };
    };

  exo.mods.comms = {
    my.halloy = {
      enable = true;
      settings = {
        # For a complete list of available options,
        # please visit https://halloy.chat/configuration.html
        check_for_update_on_launch = false;

        servers.irchighway = {
          nickname = "wyspr";
          username = "wyspr";
          realname = "wyspr";
          server = "irc.irchighway.net";
          use_tls = false;
          port = 6669;
          channels = [ "#ebooks" ];
        };

        file_transfer.save_directory = "/home/wyspr/Documents/xteink4/new";
        file_transfer.auto_accept.enabled = true;
      };

      theme = {
        ## Base16 Tokyo Night Dark
        # Author: Michaël Ball
        general = {
          background = "#1a1b26";
          border = "#d5d6db";
          horizontal_rule = "#2f3549";
          unread_indicator = "#0db9d7";
        };

        text = {
          primary = "#a9b1d6";
          secondary = "#787c99";
          tertiary = "#0db9d7";
          success = "#9ece6a";
          error = "#c0caf5";
        };

        buffer = {
          action = "#9ece6a";
          background = "#1a1b26";
          background_text_input = "#16161e";
          background_title_bar = "#16161e";
          border = "#444b6a";
          border_selected = "#d5d6db";
          code = "#bb9af7";
          highlight = "#16161e";
          nickname = "#b4f9f8";
          selection = "#2f3549";
          timestamp = "#a9b1d6";
          topic = "#787c99";
          url = "#2ac3de";
        };

        buffer.server_messages = {
          join = "#9ece6a";
          part = "#c0caf5";
          quit = "#c0caf5";
          default = "#b4f9f8";
        };

        buttons.primary = {
          background = "#1a1b26";
          background_hover = "#2f3549";
          background_selected = "#2f3549";
          background_selected_hover = "#444b6a";
        };

        buttons.secondary = {
          background = "#16161e";
          background_hover = "#2f3549";
          background_selected = "#2f3549";
          background_selected_hover = "#444b6a";
        };
      };
    };
  };
}
