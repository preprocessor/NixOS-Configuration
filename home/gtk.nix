{ config, pkgs, ... }:
{
  gtk = {
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-light";
    };

    font = {
      name = "SFPro Text";
      size = 14;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-light";
      gtk-theme = "${config.gtk.theme.name}";
    };
  };
}
