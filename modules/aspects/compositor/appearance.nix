{
  flake.modules.nixos.desktop =
    { config, ... }:
    let
      scheme = config.scheme.withHashtag;
    in
    {
      custom.programs.niri.settings = {
        layout = {
          always-center-single-column = null;
          center-focused-column = "on-overflow";
          preset-column-widths = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];
          default-column-width.proportion = 0.5;
          gaps = 25;

          background-color = "transparent";

          border = {
            width = 5;
            active-color = scheme.red;
            inactive-gradient._attrs = {
              from = scheme.base03;
              to = scheme.base03;
              relative-to = "workspace-view";
            };
            urgent-color = scheme.yellow;
          };
          focus-ring.off = null;

          shadow = {
            on = null;
            # Softness controls the shadow blur radius.
            softness = 15;

            # Spread expands the shadow.
            spread = 10;

            # Offset moves the shadow relative to the window.
            offset._attrs = {
              x = 0;
              y = 0;
            };

            # You can also change the shadow color and opacity.
            color = "#000b";
            inactive-color = "#000b";
          };
        };

        cursor = {
          xcursor-theme = "hand-of-evil";
          xcursor-size = 128;

          hide-when-typing = null;
          hide-after-inactive-ms = 5000;
        };

        overview = {
          zoom = 0.33;
          workspace-shadow.off = null;
        };

        prefer-no-csd = null;
      };
    };
}
