{
  w.desktop = {
    wrappers.niri.settings = {
      extraConfig = /* kdl */ ''
        workspace "browser" {
          layout {
            default-column-width { proportion 0.66667; }
          }
        }

        workspace "code" {
          layout {
            preset-column-widths {
              proportion 0.25;
              proportion 0.5;
              proportion 0.75;
            };
          }
        }

        workspace "social" {
          layout {
            default-column-width { proportion 1.0; }
          }
        }

        workspace "games" {
          layout {
            preset-column-widths {
              proportion 0.5;
              proportion 1.0;
            };
          }
        }

        workspace "media" {
          layout {
            default-column-width { proportion 1.0; }
          }
        }
      '';

      window-rules = [
        {
          matches = [
            {
              app-id = "^steam$";
              title = "^Steam$";
            }
          ];

          open-on-workspace = "games";
        }

        {
          matches = [
            {
              app-id = "^vesktop$";
            }
          ];

          open-on-workspace = "social";
        }
      ];
    };
  };
}
