{
  w.desktop =
    {
      scheme,
      pkgs,
      lib,
      ...
    }:
    {
      systemd.user.services.waybar = {
        description = "waybar";
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];

        serviceConfig = {
          ExecStart = lib.getExe pkgs.waybar;
          Restart = "on-failure";
        };
      };

      hj.xdg.config.files = {
        "waybar/config.jsonc".text = /* jsonc */ ''
          // -*- mode: jsonc -*-
          {
              "layer": "top",
              "position": "left",
              "exclusive": false,
              "reload_style_on_change": true,
              "modules-center": [ "hyprland/workspaces" ],
              "hyprland/workspaces":{
                "disable-click": true,
                "format": "{icon}",
                "format-icons": {

                  "web": "󰖟",
                  "dev": "",
                  "chat": "󰭹",
                  "media": "󰐎",
                  "games": "󰊖",

                  // "active": "",
                  "default": "󱥐"
                }
              }
          }
        '';

        "waybar/style.css".text = with scheme.withHashtag; /* css */ ''
          window#waybar {
              background-color: transparent;
          }

          /* non-empty workspaces */
          #workspaces button, #workspaces button:hover {
              color: ${base05};

              font-size: 12pt;

              margin: 1px 0;
              margin-left: -10px;

              padding: 0;
              padding-right: 2px;

              min-width: 38px;
              box-shadow: none;

              transition:
                color 0.3s ease;
          }

          #workspaces button.active {
              color: ${base09};
          }

          #workspaces button.urgent {
              color: ${bright-red};
          }
        '';
      };
    };
}
