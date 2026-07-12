{
  w.default =
    { config, ... }:
    {
      my.fsel = {
        enable = true;
        settings = {
          apps_border_color = "Purple";
          apps_text_color = "DarkGray";
          cursor = "▎";
          disable_mouse = true;
          fancy_mode = true;
          header_title_color = "Purple";
          highlight_color = "Yellow";
          input_border_color = "Purple";
          input_text_color = "Yellow";
          main_border_color = "Purple";
          main_text_color = "Cyan";
          pin_color = "rgb(255,165,0)";
          pin_icon = "󰐃";
          rounded_borders = false;
          title_panel_height_percent = 20;
          title_panel_position = "bottom";

          app_launcher = {
            filter_actions = true;
            filter_desktop = true;
            list_executables_in_path = false;
          };

          cclip.image_preview = true;

          dmenu = {
            delimiter = " ";
            disable_mouse = true;
            show_line_numbers = true;
          };
        };
      };

      my.otter-launcher = {
        settings.general = {
          empty_module = "find";
          default_module = "app";
        };

        modules =
          let
            spawn = config.utils.hyprSpawn;
          in
          [
            {
              cmd = spawn 500 1000 "fsel" ''fsel -d -r -ss "{}"'';
              description = "search";
              prefix = "find";
              with_argument = true;
              unbind_proc = true;
            }
            {
              cmd = spawn 500 1000 "fsel" ''fsel -d -r -p "{}"'';
              description = "launch";
              prefix = "app";
              with_argument = true;
              unbind_proc = true;
            }
          ];
      };

      _file = ./settings.nix;
    };
}
