{
  exo.mods.desktop = {
    my.tray-tui = {
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
  };

  exo.skeleton =
    {
      config,
      pkgs,
      wrapPackage,
      lib,
      ...
    }:
    let
      cfg = config.my.tray-tui;
      toml = pkgs.formats.toml { };
    in
    {
      options.my.tray-tui = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into tray-tui's toml config";
        };

        package = lib.mkOption {
          default = wrapPackage (
            { files, wlib, ... }:
            {
              package = pkgs.tray-tui;
              args = [
                ''--config-path "${files.config}"''
              ];
              files.config = {
                relPath = "config/config.toml";
                file = wlib.toml "config.toml" cfg.settings;
              };
            }
          );
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];

        my.xdg.desktopTuiEntries."Tray TUI" = {
          package = config.my.tray-tui.package;
          width = 1200;
          height = 1200;
        };
      };
    };
}
