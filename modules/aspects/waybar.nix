{
  w.desktop =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.waybar ];

      wrappers.niri.settings.spawn-at-startup = [
        "waybar"
      ];

      hj.xdg.config.files = {
        "waybar/config.jsonc".text = /* jsonc */ ''
          // -*- mode: jsonc -*-
          {
              "layer": "top", // Waybar at top layer
              "position": "left", // Waybar position (top|bottom|left|right)
              "exclusive": false,
              "reload_style_on_change": true,
              "modules-center": [ "niri/workspaces" ],
              "niri/workspaces":{
                "disable-click": true,
                "format": "{icon}",
                "format-icons": {
                  "1": "☾",

                  "browser": "󰖟",
                  "code": "",
                  "social": "󰭹",
                  "media": "󰐎",
                  "games":"󰊖",

                  // "active": "",
                  "default": "󱥐"
                }
              }
          }
        '';

        "waybar/style.css".text = /* css */ ''
          window#waybar {
              background-color: transparent;
          }

          /* non-empty workspaces */
          #workspaces button, #workspaces button:hover {
              color: #000;

              font-size: 12pt;

              margin: 1px 0;
              margin-left: -10px;

              padding: 0;
              padding-right: 2px;

              min-width: 38px;
              text-shadow:0 0 2px #444;
              box-shadow: none;

              transition:
                color 0.3s ease,
                text-shadow 0.3s ease;
          }

          #workspaces button.focused {
              color: #fff;
              text-shadow:
                0 0 1px #000,
                0 0 2px #111,
                0 0 3px #222,
                0 0 4px #333
              ;
          }

          /* moon reposition */
          #workspaces button:first-child {
            padding-left: 3px;
            padding-right: 0px;
          }

          /* moon selected color */
          #workspaces button:first-child.focused {
              color: #ff0;
          }

          #workspaces button.urgent {
              background-color: #f00;
          }
        '';
      };
    };
}
