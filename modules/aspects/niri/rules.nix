{
  w.desktop.custom.programs.niri.settings = {
    window-rules = [
      {
        # Floating windows
        matches = [
          # Open the picture-in-picture player as floating as well as browser settings
          {
            app-id = "^vivaldi-snapshot$";
            title = "^Vivaldi Settings";
          }
          # Steam rules
          {
            app-id = "^steam$";
            title = "^Steam Settings$";
          }
          {
            app-id = "^steam$";
            title = "^Friends List$";
          }
          {
            app-id = "^steam$";
            title = "^Controller Layout$";
          }
          {
            app-id = "^steam$";
            title = "^Steam Controller Configs$";
          }
          # Waypaper
          {
            app-id = "^waypaper$";
            title = "^Waypaper$";
          }
          {
            title = "^SteamTinkerLaunch.*$";
          }
          {
            app-id = "^zenity$";
            title = "^ProtonFixes$";
          }
        ];
        open-floating = true;
      }

      {
        # block out password manager from screen capture.
        matches = [
          { app-id = "^org\.keepassxc\.KeePassXC$"; }
        ];

        block-out-from = "screen-capture";

        # Use this instead if you want them visible on third-party screenshot tools.
        # block-out-from "screencast"
      }
      {
        draw-border-with-background = false;
      }
      {
        matches = [
          { app-id = "steam"; }
          { title = "^notificationtoasts_\d+_desktop$"; }
        ];
        default-floating-position = _: {
          props = {
            x = 20;
            y = 20;
            relative-to = "bottom-right";
          };
        };
      }
      {
        matches = [
          { title = "^Picture-in-Picture$"; }
          { title = "^Picture in picture$"; }
        ];

        open-floating = true;
        default-floating-position = _: {
          props = {
            x = 10;
            y = 10;
            relative-to = "bottom-right";
          };
        };
      }

    ];

    layer-rules = [
      {
        # Background for switcher
        matches = [ { namespace = "^awww-daemon$"; } ];
        place-within-backdrop = true;
      }
    ];
  };
}
