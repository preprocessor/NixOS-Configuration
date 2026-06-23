{
  w.desktop =
    { scheme, ... }:
    {
      wrappers.waybar = {
        enable = true;

        config = [
          {
            name = "left";
            position = "left";
            layer = "top";
            exclusive = false;
            reload_style_on_change = true;
            modules-center = [ "hyprland/workspaces" ];
            "hyprland/workspaces" = {
              disable-click = true;
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
          }
        ];

        style = with scheme.withHashtag; /* css */ ''
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
