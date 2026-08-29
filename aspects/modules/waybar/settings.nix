{
  exo.mods.desktop =
    {
      pkgs,
      scheme,
      ...
    }:
    {
      my.waybar = {
        enable = true;

        config = {
          layer = "top";
          position = "bottom";
          exclusive = false;
          width = 700;
          margin-bottom = -4;
          spacing = 0;
          reload_style_on_change = true;
          modules-center = [
            "custom/hyprlayout"
            "hyprland/workspaces"
          ];
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
          "custom/hyprlayout" = {
            exec = pkgs.writeShellScript "waybar-hyprlayout" ''
              LAYOUT=$(hyprctl activeworkspace -j | jq -r .tiledLayout)
              echo "{\"text\": \"text\", \"alt\": \"$LAYOUT\", \"tooltip\": \"tooltip\", \"class\": \"hyprlayout\", \"percentage\": 0 }"
            '';
            return-type = "json";
            interval = 1;
            format = "{icon}";
            format-icons = {
              scrolling = "󰕭 ";
              dwindle = "󰕴 ";
              master = "󰕬 ";
            };
          };
        };

        style = with scheme.withHashtag; /* css */ ''
          window#waybar {
            background-color: transparent;
            font-family: "Chicago";
            color: ${base04};
          }

          /* non-empty workspaces */
          #workspaces button, #workspaces button:hover {
            font-size: 14pt;
            color: ${base04};

            padding: 0 8px 0 0;

            transition: color 0.3s ease, text-shadow 0.3s ease;
          }

          #workspaces button:hover {
            text-shadow: none;
            box-shadow: none;
            background: none;
            border: none;
          }

          #workspaces button.active {
            color: ${base05};
          }

          #workspaces button.urgent {
            color: ${bright-red};
          }

          #custom-hyprlayout {
            font-size: 14pt;
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
