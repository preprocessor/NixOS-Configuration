{
  w.desktop =
    { lib, ... }:
    let
      cursor-theme = "Posy_Cursor_Black";
      cursor-size = "32";
      gtk-theme = "Tokyonight-Dark-Compact";
      icon-theme = "Tela-dracula-dark";

      shared = ''
        gtk-theme-name=${gtk-theme}
        gtk-icon-theme-name=${icon-theme}
        gtk-font-name=SF Pro 12
        gtk-cursor-theme-name=${cursor-theme}
        gtk-cursor-theme-size=${cursor-size}
      '';
    in
    {
      hj.files.".gtkrc-2.0".text = /* ini */ ''
        ${shared}
        gtk-toolbar-style=GTK_TOOLBAR_ICONS
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=0
        gtk-menu-images=0
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=0
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';

      hj.xdg.config.files = {
        "gtk-3.0/settings.ini".text = /* ini */ ''
          [Settings]
          ${shared}
          gtk-application-prefer-dark-theme=1
          gtk-toolbar-style=GTK_TOOLBAR_ICONS
          gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
          gtk-button-images=0
          gtk-menu-images=0
          gtk-enable-event-sounds=1
          gtk-enable-input-feedback-sounds=0
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintslight
          gtk-xft-rgba=rgb
        '';

        "gtk-4.0/settings.ini".text = /* ini */ ''
          [Settings]
          ${shared}
          gtk-application-prefer-dark-theme=1
        '';

        "xsettingsd/xsettingsd.conf".text = ''
          Net/ThemeName "Tokyonight-Dark-Compact"
          Net/IconThemeName "Tela-dracula-dark"
          Gtk/CursorThemeName "Posy_Cursor_Black"
          Net/EnableEventSounds 1
          EnableInputFeedbackSounds 0
          Xft/Antialias 1
          Xft/Hinting 1
          Xft/HintStyle "hintslight"
          Xft/RGBA "rgb"
        '';
      };

      programs.dconf = {
        enable = true;

        # custom option, the default nesting is horrendous
        profiles.user.databases = [
          {
            settings = {
              # disable dconf first use warning
              "ca/desrt/dconf-editor" = {
                show-warning = false;
              };
              # gtk related settings
              "org/gnome/desktop/interface" = {
                inherit cursor-theme gtk-theme icon-theme;
                color-scheme = "prefer-dark"; # set dark theme for gtk 4
                cursor-size = lib.gvariant.mkUint32 cursor-size;
                # disable middle click paste
                gtk-enable-primary-paste = false;
              };
            };
          }
        ];
      };
    };
}
