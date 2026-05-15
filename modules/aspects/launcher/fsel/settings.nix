{ config, ... }:
let
  resize = config.utils.otterResize;
in
{
  w.desktop = {
    wrappers.otter-launcher.settings = {
      modules = [
        {
          description = "search apps";
          prefix = "find";
          cmd = resize 500 1000 ''fsel -d -r -ss "{}"'';
          with_argument = true;
        }
        {
          description = "launch apps";
          prefix = "app";
          cmd = resize 500 1000 ''fsel -d -r -p "{}"'';
          with_argument = true;
        }
      ];

      general = {
        empty_module = "find";
        default_module = "app";
      };
    };

    wrappers.fsel = {
      enable = true;
      settings = {
        # ===== COLORS =====
        # WARNING: Color options go at ROOT LEVEL (not in [app_launcher])
        # Note: Colors can be overridden in [dmenu] and [cclip] sections for mode-specific styling
        # Formats: Named ("Red", "LightBlue"), Hex ("#ff0000", "#f00"),
        #          RGB ("rgb(255,0,0)"), 8-bit ("196")

        # Border colors for each panel
        main_border_color = "Purple"; # Border color for the main info panel (top)
        apps_border_color = "Purple"; # Border color for the apps list panel (middle)
        input_border_color = "Purple"; # Border color for the input panel (bottom)

        # Text Colors (non-highlighted text in each panel)
        main_text_color = "Cyan"; # Text color for the main info panel
        apps_text_color = "DarkGray"; # Text color for the apps list
        input_text_color = "Yellow"; # Text color for the input field

        # Highlight color for selected items and cursor
        highlight_color = "Yellow";
        # Panel title color
        header_title_color = "Purple";

        cursor = "▎";

        rounded_borders = false;

        disable_mouse = true;

        # Top panel height as percentage (0-70%)
        # Set to 0 to hide the title/content panel entirely
        title_panel_height_percent = 20;

        # Title panel position: "top", "middle", or "bottom"
        title_panel_position = "bottom";

        # Pin/Favorite Settings
        pin_color = "rgb(255,165,0)"; # Color for pin icon (default: orange)
        pin_icon = "󰐃"; # Icon for pinned apps (use Ctrl+Space to pin/unpin)

        # Show selected app name in panel titles (instead of "Apps"/"Fsel")
        fancy_mode = true;

        # App launcher specific options
        app_launcher = {
          filter_desktop = true;
          filter_actions = true;
          list_executables_in_path = false;

          launch_prefix = [
            "app2unit"
            "--"
          ];
        };

        # Dmenu mode overrides
        dmenu = {
          delimiter = " ";
          show_line_numbers = true;
          disable_mouse = true;
        };
        # Clipboard mode overrides
        cclip = {
          image_preview = true;
        };
      };
    };

    _file = ./settings.nix;
  };
}
