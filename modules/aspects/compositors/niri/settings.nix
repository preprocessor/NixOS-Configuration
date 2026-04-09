{ self, ... }:
{
  flake.modules.nixos.desktop =
    {
      lib,
      pkgs,
      ...
    }:
    {
      custom.programs.niri.settings = {
        clipboard.disable-primary = true;
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        screenshot-path = self.const.homedir + "/Pictures/Screenshots/%Y-%m-%d %H:%M:%S.png";
        gestures.hot-corners.off = null;

        outputs."DP-2" = {
          mode = "3440x1440@74.983";
          variable-refresh-rate._attrs.on-demand = true;
        };

        input = {
          keyboard = {
            xkb.options = "caps:escape";
            repeat-delay = 200;
            repeat-rate = 40;
            # Enable numlock on startup, omitting this setting disables it.
            numlock = null;
          };

          touchpad.off = null;
          trackpoint.off = null;
          mouse = {
            # natural-scroll
            # accel-speed 0.2
            # accel-profile "flat"
            # scroll-method "no-scroll"
          };

          # Focus windows and outputs automatically when moving the mouse into them.
          # Setting max-scroll-amount="0%" makes it work only on windows already fully on screen.
          focus-follows-mouse._attrs.max-scroll-amount = "0%";
          warp-mouse-to-focus = null;
          workspace-auto-back-and-forth = null;
          mod-key = "Super";
          mod-key-nested = "Alt";

        };
        extraConfig = /* kdl */ ''
          include optional=true "${self.const.homedir}/.config/niri/dyn.kdl";
        '';
      };
    };
}
