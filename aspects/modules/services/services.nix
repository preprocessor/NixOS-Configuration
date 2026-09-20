{
  exo.mods.desktop =
    { lib, ... }:
    {
      my.xdg.desktopEntries."uuctl".noDisplay = true;

      services = {
        graphical-desktop.enable = true;
        speechd.enable = lib.mkForce false;
        dbus.implementation = "broker";
        power-profiles-daemon.enable = true;
      };
    };
}
