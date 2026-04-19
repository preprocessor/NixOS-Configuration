# Based on: https://github.com/iynaix/dotfiles/blob/7cfd3aec29feec3807206591260e594ad28094f9/modules/gui/gtk/default.nix
{ lib, ... }:
{
  w.desktop =
    { config, ... }:
    let
      gtkCfg = config.custom.gtk;
      toIni = lib.generators.toINI {
        mkKeyValue =
          key: value:
          let
            value' = if lib.isBool value then lib.boolToString value else toString value;
          in
          "${lib.escape [ "=" ] key}=${value'}";
      };
      gtkIni = toIni {
        Settings = {
          gtk-theme-name = gtkCfg.theme.name;
          gtk-icon-theme-name = config.custom.gtk.iconTheme.name;
          gtk-application-prefer-dark-theme = 1;
          gtk-error-bell = 0;
        };
      };
    in
    {
      environment = {
        etc = {
          "xdg/gtk-3.0/settings.ini".text = gtkIni;
          "xdg/gtk-4.0/settings.ini".text = gtkIni;
          "xdg/gtk-2.0/gtkrc".text = ''
            gtk-icon-theme-name = "${config.custom.gtk.iconTheme.name}";
            gtk-theme-name = "${gtkCfg.theme.name}";
          '';
        };

        sessionVariables = {
          GTK2_RC_FILES = "/etc/xdg/gtk-2.0/gtkrc";
        };
      };

      # use per user settings
      hj.xdg.config.files."gtk-3.0/bookmarks".text = lib.concatMapStringsSep "\n" (
        b: "file://${b}"
      ) gtkCfg.bookmarks;

      programs.dconf = {
        enable = true;

        # custom option, the default nesting is horrendous
        profiles.user.databases = [
          {
            settings = lib.mkMerge [
              {
                # disable dconf first use warning
                "ca/desrt/dconf-editor" = {
                  show-warning = false;
                };
                # gtk related settings
                "org/gnome/desktop/interface" = {
                  color-scheme = "prefer-dark"; # set dark theme for gtk 4
                  cursor-theme = gtkCfg.cursor.name;
                  cursor-size = lib.gvariant.mkUint32 gtkCfg.cursor.size;
                  gtk-theme = gtkCfg.theme.name;
                  icon-theme = gtkCfg.iconTheme.name;
                  # disable middle click paste
                  gtk-enable-primary-paste = false;
                };
              }
              config.custom.dconf.settings
            ];
          }
        ];
      };

    };
}
