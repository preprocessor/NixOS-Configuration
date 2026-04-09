{
  flake.modules.nixos.desktop =
    { config, ... }:
    let
      scheme = config.scheme.withHashtag;
    in
    {
      custom.programs.niri.settings = {
        layout = {
          center-focused-column = "on-overflow";
          always-center-single-column = null;
          empty-workspace-above-first = null;

          default-column-width.proportion = 0.5;
          preset-column-widths = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];

          gaps = 25;

          background-color = "transparent";

          border = {
            off = null;
            width = 2;
            active-color = scheme.base05;
            inactive-color = scheme.base02;
            urgent-color = scheme.base0F;
          };

          focus-ring = {
            on = null;
            width = 2;
            active-color = scheme.base05;
          };

          shadow = {
            on = null;
            softness = 15;
            spread = 10;
            offset._attrs = {
              x = 0;
              y = 0;
            };

            # You can also change the shadow color and opacity.
            color = scheme.base11;
            inactive-color = scheme.base11;
          };
        };

        cursor = {
          # xcursor-theme = "hand-of-evil";
          # xcursor-size = 128;

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
