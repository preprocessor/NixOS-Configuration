{
  exo.mods.desktop =
    { scheme, ... }:
    {
      my.waybar = {
        enable = true;

        config = {
          layer = "top";
          position = "bottom";
          exclusive = false;
          margin-bottom = -1;
          spacing = 0;
          reload_style_on_change = true;
          modules-center = [ "hyprland/workspaces" ];
          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              web = "󰖟";
              dev = "";
              chat = "󰭹";
              media = "󰐎";
              games = "󰊖";
            };
          };
        };

        style =
          with scheme;
          let
            foreground = base00;
            highlight = bright-cyan;
          in
          /* css */ ''
            window#waybar {
              background-color: transparent;
              color: ${foreground};
              font-family: "Chicago";
            }

            #workspaces button, #workspaces button:hover {
              text-shadow: none;
              box-shadow: none;
              background: none;
              border: none;

              font-size: 14pt;
              color: ${foreground};

              padding: 0 3px;
              transition: color 0.3s ease, text-shadow 0.1s linear;
            }

            #workspaces button.active {
              color: ${highlight};
              text-shadow: 
                 1px  0px 2px rgba(0, 0, 0, 0.5),
                 0px  1px 2px rgba(0, 0, 0, 0.5),
                -1px  0px 2px rgba(0, 0, 0, 0.5),
                 0px -1px 2px rgba(0, 0, 0, 0.5);
            }

            #workspaces button.urgent {
              color: ${bright-red};
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
