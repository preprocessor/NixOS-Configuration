{
  w.desktop =
    { schemeHash, ... }:
    {
      wrappers.niri.settings =
        let
          set = _: { };
        in
        with schemeHash;
        {
          window-rules = [
            { draw-border-with-background = false; }
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
                  app-id = "^com.interversehq.qView$";
                }
              ];
              open-floating = true;
            }

            {
              matches = [
                { title = "login"; }
                { title = "signin"; }
                { app-id = "org.keepassxc.KeePassXC"; }
                { app-id = "equibop"; }
                # { app-id = "discord"; }
                { app-id = "thunderbird"; }
              ];
              block-out-from = "screencast";
              focus-ring = {
                active.color = "#f38ba8";
              };

              border = {
                inactive.color = "#7d0d2d";
                width = 3;
              };

              shadow.off = set;

              tab-indicator = {
                active.color = "#f38ba8";
                inactive.color = "#7d0d2d";
              };
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
              clip-to-geometry = true; # disable CSD and shadows

              default-floating-position = _: {
                props = {
                  x = 10;
                  y = 10;
                  relative-to = "bottom-right";
                };
              };
            }

            {
              matches = [
                { app-id = "^kitty$"; }
                { app-id = "^otter$"; }
              ];

              background-effect = {
                blur = true;
              };
            }

            {
              matches = [
                { app-id = "^kitty$"; }
                { app-id = "^otter$"; }
                { is-floating = true; }
              ];

              background-effect = {
                blur = true;
                xray = false;
              };
            }

          ];

          layer-rules = [
            {
              matches = [
                { namespace = "notifications"; }
              ];
              block-out-from = "screencast";
            }
            {
              # Background for switcher
              matches = [ { namespace = "^awww-daemon$"; } ];
              place-within-backdrop = true;
            }
            {
              # Background for switcher
              matches = [ { namespace = "^kitty-quick-access$"; } ];
              background-effect = {
                xray = false;
                blur = true;
              };
            }
          ];
        };
    };
}
