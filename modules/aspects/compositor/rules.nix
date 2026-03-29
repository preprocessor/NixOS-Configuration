{
  flake.modules.nixos.desktop.custom.programs.niri.settings = {
    window-rules = [
      {
        # Floating windows
        matches = [
          # Open the picture-in-picture player as floating as well as browser settings
          { title = "^Picture-in-Picture$"; }
          {
            app-id = "^vivaldi-stable$";
            title = "^Vivaldi Settings$";
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
      # {
      #   matches = [ { app-id = "^com\.mitchellh\.ghostty$"; } ];
      #   draw-border-with-background = false;
      # }

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
