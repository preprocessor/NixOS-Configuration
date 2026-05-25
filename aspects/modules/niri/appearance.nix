{
  w.desktop =
    { config, schemeHash, ... }:
    let
      set = _: { };
    in
    {
      wrappers.niri.settings = {

        layout = with schemeHash; {
          center-focused-column = "on-overflow";
          always-center-single-column = set;
          empty-workspace-above-first = set;

          default-column-width.proportion = 0.5;
          preset-column-widths = [
            { proportion = 0.25; }
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
            active-color = base0A;
            fade-duration-ms = 300;
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

            color = base00;
            inactive-color = base00;
          };
        };

        blur = {
          passes = 2;
          offset = 3;
          noise = 0.02;
          saturation = 1.5;
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
      _file = ./appearance.nix;
    };
}
