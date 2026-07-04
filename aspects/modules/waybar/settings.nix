{
  w.desktop =
    {
      pkgs,
      scheme,
      config,
      ...
    }:
    {
      custom.programs.waybar = {
        enable = true;

        config = {
          layer = "top";
          position = "bottom";
          exclusive = false;
          width = 700;
          margin-bottom = -3;
          spacing = 0;
          reload_style_on_change = true;
          modules-left = [
            "custom/hyprlayout"
            "hyprland/workspaces"
          ];
          modules-center = [ "clock" ];
          modules-right = [ "custom/histui" ];
          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              web = "󰖟";
              dev = "";
              chat = "󰭹";
              media = "󰐎";
              games = "󰊖";

              # active = "";
              default = "󱥐";
            };
          };
          "custom/histui" =
            let
              spawn = config.utils.hyprSpawn;
            in
            {
              exec = "histui status --detailed";
              return-type = "json";
              interval = 5;
              format = "{icon} {text}";
              format-icons = {
                empty = ""; # No notifications
                dnd = "󰂛"; # Do Not Disturb
                low = "󱅫"; # Low priority
                normal = "󱅫"; # Normal priority
                critical = "󰂚"; # Critical notification
              };
              on-click = "histui dnd toggle";
              on-click-right = spawn 1300 600 "histui" "histui tui";
              # on-click-middle = "histui get --format dmenu --since 24h | fuzzel --dmenu -p 'Notifications'";
            };

          "custom/hyprlayout" = {
            exec = pkgs.writeShellScript "waybar-hyprlayout" ''
              LAYOUT=$(hyprctl activeworkspace -j | jq -r .tiledLayout)

              echo "{\"text\": \"\", \"alt\": \"$LAYOUT\", \"tooltip\": \"\", \"class\": \"hyprlayout\", \"percentage\": 0 }"
            '';
            return-type = "json";
            interval = 1;
            format = "{icon}";
            format-icons = {
              scrolling = "󰕭 ";
              "lua:centercol" = "󰕬 ";
              dwindle = "󰕴 ";
            };
          };

        };

        style = with scheme.withHashtag; /* css */ ''
          window#waybar {
            background-color: transparent;
            font-family: "Chicago";
            color: ${base05};
          }

          /* non-empty workspaces */
          #workspaces button, #workspaces button:hover {
            font-size: 14pt;
            color: ${base05};

            padding: 0 8px 0 0;

            transition: color 0.3s ease;
          }

          #workspaces button.active {
            color: ${base09};
          }

          #workspaces button.urgent {
            color: ${bright-red};
          }

          #custom-hyprlayout {
            font-size: 14pt;
          }

          #custom-histui {
            margin-right: 80px;
          }

          /* Do Not Disturb active */
          #custom-histui.dnd {
            color: ${base01};
          }

          /* Has unread notifications */
          #custom-histui.has-notifications {
            color: ${bright-yellow};
          }

          /* Critical notification pending */
          #custom-histui.critical {
            color: ${bright-red};
            animation: pulse 1s ease-in-out infinite;
          }

          @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
          }
        '';
      };
    };
}
