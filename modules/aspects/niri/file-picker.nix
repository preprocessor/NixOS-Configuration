{
  w.desktop =
    { lib, ... }:
    {
      xdg.portal.config.niri = {
        "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "termfilechooser" ];
        default = lib.mkForce [ "gnome" ];
        "org.freedesktop.impl.portal.Secret" = lib.mkForce [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.Chooser" = lib.mkForce [ "none" ];
      };
    };
}
