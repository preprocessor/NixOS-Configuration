{
  w.default =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.custom.gtk;
      ini = (pkgs.formats.iniWithGlobalSection { }).generate;

      gtk-common = {
        gtk-theme-name = cfg.theme.name;
        gtk-icon-theme-name = cfg.icons.name;
        gtk-cursor-theme-name = cfg.cursor.name;
        gtk-cursor-theme-size = cfg.cursor.size;
        gtk-font-name = with cfg.font; "${name} ${size}";
      };

      gtk2-3-common = {
        gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 0;
        gtk-menu-images = 0;
        gtk-enable-event-sounds = 1;
        gtk-enable-input-feedback-sounds = 0;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
      };

      gtk3-4-common.gtk-application-prefer-dark-theme = 1;

      default_cursor_path = with cfg.cursor; "${package}/share/icons/${name}/cursors/left_ptr";

      default_index_theme_package = pkgs.writeTextFile {
        name = "index.theme";
        destination = "/share/icons/default/index.theme";
        # Set name in icons theme, for compatibility with AwesomeWM etc. See:
        # https://github.com/nix-community/home-manager/issues/2081
        # https://wiki.archlinux.org/title/Cursor_themes#XDG_specification
        text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${cfg.cursor.name}
        '';
      };
    in
    {
      config = lib.mkIf (cfg.enable) {
        hj.packages = [
          cfg.theme.package
          cfg.cursor.package
          default_index_theme_package
        ];

        hj.environment.sessionVariables = {
          XCURSOR_SIZE = cfg.cursor.size;
          XCURSOR_THEME = cfg.cursor.name;
        };

        hj.xdg.data.files = {
          "icons/${cfg.cursor.name}".source = "${cfg.cursor.package}/share/icons/${cfg.cursor.name}";

          "icons/default/index.theme".source =
            "${default_index_theme_package}/share/icons/default/index.theme";
        };

        hj.xdg.config.files = {
          "xsettingsd/xsettingsd.conf".text = ''
            Net/ThemeName "${cfg.theme.name}"
            Net/IconThemeName "${cfg.icons.name}"
            Gtk/CursorThemeName "${cfg.cursor.name}"
          ''
          + (with gtk2-3-common; ''
            Net/EnableEventSounds ${toString gtk-enable-event-sounds}
            EnableInputFeedbackSounds ${toString gtk-enable-input-feedback-sounds}
            Xft/Antialias ${toString gtk-xft-antialias}
            Xft/Hinting ${toString gtk-xft-hinting}
            Xft/HintStyle "${gtk-xft-hintstyle}"
            Xft/RGBA "${gtk-xft-rgba}"
          '');

          "gtk-4.0/settings.ini".source = ini "gtkrc-2.0" {
            sections."Settings" = gtk-common // gtk3-4-common;
          };

          "gtk-3.0/settings.ini".source = ini "gtkrc-2.0" {
            sections."Settings" = gtk-common // gtk2-3-common // gtk3-4-common;
          };
        };

        hj.files = {
          ".gtkrc-2.0".source = ini "gtkrc-2.0" {
            globalSection = gtk-common // gtk2-3-common;
          };

          ".icons/default/index.theme".source =
            "${default_index_theme_package}/share/icons/default/index.theme";

          ".icons/${cfg.cursor.name}".source = "${cfg.cursor.package}/share/icons/${cfg.cursor.name}";

          ".Xresources".text = ''
            Xcursor.theme = ${cfg.cursor.name};
            Xcursor.size = ${cfg.cursor.size};
          '';

          ".xprofile".text = /* bash */ ''
            if [ -e "$HOME/.profile" ]; then
              . "$HOME/.profile"
            fi

            # If there are any running services from a previous session.
            # Need to run this in xprofile because the NixOS xsession
            # script starts up graphical-session.target.
            systemctl --user stop graphical-session.target graphical-session-pre.target

            ${lib.getExe pkgs.xsetroot} -xcf ${default_cursor_path} ${cfg.cursor.size}

            export HM_XPROFILE_SOURCED=1
          '';
        };

        programs.dconf = {
          enable = true;

          profiles.user.databases = [
            {
              settings = {
                # disable dconf first use warning
                "ca/desrt/dconf-editor" = {
                  show-warning = false;
                };
                # gtk related settings
                "org/gnome/desktop/interface" = {
                  gtk-theme = cfg.theme.name;
                  icon-theme = cfg.icons.name;
                  cursor-theme = cfg.cursor.name;
                  cursor-size = cfg.cursor.size;
                  color-scheme = "prefer-dark"; # set dark theme for gtk 4
                  # disable middle click paste
                  gtk-enable-primary-paste = false;
                };
              };
            }
          ];
        };
      };

      options.custom.gtk = {
        enable = lib.mkEnableOption { };

        theme = {
          name = lib.mkOption {
            description = "GTK Theme";
            type = lib.types.str;
            default = "Adwaita";
          };

          package = lib.mkOption {
            description = "GTK Theme package";
            type = lib.types.nullOr lib.types.package;
            default = null;
          };
        };

        icons = {
          name = lib.mkOption {
            description = "GTK Icon theme";
            type = lib.types.str;
            default = "Adwaita";
          };

          package = lib.mkOption {
            description = "GTK Icon theme package";
            type = lib.types.nullOr lib.types.package;
            default = pkgs.adwaita-icon-theme;
          };
        };

        cursor = {
          name = lib.mkOption {
            description = "Cursor theme";
            type = lib.types.str;
            default = "Adwaita";
          };

          size = lib.mkOption {
            description = "Cursor size";
            type = lib.types.int;
            default = 32;
            apply = toString;
          };

          package = lib.mkOption {
            description = "Cursor theme package";
            type = lib.types.nullOr lib.types.package;
            default = pkgs.adwaita-icon-theme;
          };
        };

        font = {
          name = lib.mkOption {
            description = "Font name";
            type = lib.types.str;
            default = config.fonts.fontconfig.defaultFonts.sansSerif |> lib.head;
          };

          size = lib.mkOption {
            description = "Font size";
            type = lib.types.int;
            default = 12;
            apply = toString;
          };

          package = lib.mkOption {
            description = "Font package";
            type = lib.types.nullOr lib.types.package;
            default = null;
          };
        };
      };

      _file = "gtk/module.nix";
    };
}
