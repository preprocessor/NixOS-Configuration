{
  w.default =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = with pkgs; [
        app2unit
      ];

      custom.xdg.desktopEntries."uuctl".noDisplay = true;

      hj.environment.sessionVariables = {
        APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
        APP2UNIT_TYPE = "service";
        # This is a workaround to set NIXOS_OZONE_WL as described in https://wiki.nixos.org/wiki/Wayland#Electron_and_Chromium
        NIXOS_OZONE_WL = "1";
      };

      services.graphical-desktop.enable = true;
      services.speechd.enable = lib.mkForce false;

      _file = ./wayland.nix;
    };
}
