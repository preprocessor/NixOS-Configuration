{
  w.default =
    { config, lib, ... }:
    {
      custom.programs.tray-tui = {
        enable = true;
        settings = {

          columns = 3;
          min_height = 4;
          mouse = false;
          scrollbar = true;
          sorting = false;

          colors = {
            bg = "reset";
            bg_focused = "reset";
            bg_highlighted = "green";
            border_bg = "reset";
            border_bg_focused = "reset";
            border_fg = "white";
            border_fg_focused = "green";
            fg = "white";
            fg_focused = "white";
            fg_highlighted = "black";
          };

          key_map = {
            ctrl-c = "quit";
            down = "focus_down";
            enter = "activate";
            esc = "quit";
            h = "focus_left";
            j = "focus_up";
            k = "focus_down";
            l = "focus_right";
            left = "focus_left";
            q = "quit";
            right = "focus_right";
            shift-down = "menu_down";
            shift-up = "menu_up";
            up = "focus_up";
          };

          symbols = {
            highlight_symbol = "";
            node_closed_symbol = " ⏷ ";
            node_no_children_symbol = " ";
            node_open_symbol = " ▶ ";
          };
        };
      };

      custom.programs.otter-launcher.modules =
        let
          spawn = config.utils.hyprSpawn;
        in
        [
          {
            cmd = spawn 1200 1200 "tray-tui" (lib.getExe config.custom.programs.tray-tui.package);
            description = "systray";
            prefix = "tray";
          }
        ];

      _file = ./settings.nix;
    };
}
