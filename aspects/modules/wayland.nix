{
  exo.mods.desktop =
    { lib, ... }:
    {
      my.xdg.desktopEntries."uuctl".noDisplay = true;
      services.graphical-desktop.enable = true;
      services.speechd.enable = lib.mkForce false;
    };
}
