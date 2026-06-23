{ ... }@top:
let
  resize = top.config.utils.otterResize;
in
{
  w.default = {
    wrappers.fsel = {
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

    wrappers.otter-launcher = {
      settings.general = {
        empty_module = "find";
        default_module = "app";
      };

      modules = [
        {
          cmd = resize 500 1000 ''fsel -d -r -ss "{}"'';
          description = "search apps";
          prefix = "find";
          with_argument = true;
          unbind_proc = true;
        }
        {
          cmd = resize 500 1000 ''fsel -d -r -p "{}"'';
          description = "launch apps";
          prefix = "app";
          with_argument = true;
          unbind_proc = true;
        }
      ];
    };

    _file = ./settings.nix;
  };
}
