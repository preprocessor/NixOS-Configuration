{
  flake.modules.nixos.desktop =
    { config, ... }:
    let
      scheme = config.scheme.withHashtag;
      set = _: { };
    in
    {
      custom.programs.niri.settings = {
        layout = {
          center-focused-column = "on-overflow";
          always-center-single-column = set;
          empty-workspace-above-first = set;

          default-column-width.proportion = 0.5;
          preset-column-widths = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];

          gaps = 25;

          background-color = "transparent";

          border.off = set;

          focus-ring = {
            on = set;
            width = 1;
            active-color = scheme.base05;
            # fade-duration-ms = 500;
          };

          shadow = {
            on = set;
            softness = 10;
            spread = 10;
            offset = _: {
              props = {
                x = 0;
                y = 0;
              };
            };

            # You can also change the shadow color and opacity.
            color = scheme.base11;
            inactive-color = scheme.base11;
          };
        };

        cursor = {
          # xcursor-theme = "hand-of-evil";
          # xcursor-size = 128;

          # shake {
          #   off
          #   max-multiplier 2.5
          #   post-expand-delay-ms 250
          #   expand-duration-ms 200
          #   decay-duration-ms 300
          #   shake-interval-ms 400
          #   min-diagonal 100.0
          #   sensitivity 2.0
          # }

          hide-when-typing = set;
          hide-after-inactive-ms = 5000;
        };

        overview = {
          zoom = 0.33;
          workspace-shadow.off = set;
        };

        prefer-no-csd = set;
      };
    };
}
