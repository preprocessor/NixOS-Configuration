{ config, ... }:
let
  colors = config.scheme;

  background = colors.base01;
  foreground = colors.base05;

  border = {
    width = 4;

    inactive = {
      outer = colors.base03;
      mid = colors.base04;
      inner = colors.base06;
      text = background;
    };
    active = {
      outer = colors.base11;
      mid = background;
      inner = colors.base03;
      text = foreground;
    };
  };
in
{
  home-manager.users.wyspr.xdg.configFile."canoe/canoe.toml".text = ''
    launcher_cmd = "fuzzel"
    terminal_cmd = "ghostty"

    [ui]
    border_width = ${builtins.toString border.width}
    border_active = { outer = "#${border.active.outer}", mid = "#${border.active.mid}", inner = "#${border.active.inner}" }
    border_inactive = { outer = "#${border.inactive.outer}", mid = "#${border.inactive.mid}", inner = "#${border.inactive.inner}" }
    titlebar_text_active = "#${border.active.text}"
    titlebar_text_inactive = "#${border.inactive.text}"
    titlebar_bg_active = "#${border.active.mid}"
    titlebar_bg_inactive = "#${border.inactive.mid}"

    menu_bg = "#${background}"
    menu_text = "#${foreground}"
    menu_highlight_bg = "#${colors.base02}"
    menu_highlight_text = "#${colors.base06}"

    button_highlight = "#${background}"
    button_bg = "#${colors.base03}"
    button_shadow = "#${colors.base04}"

    font_name = "New York Medium:style=Regular"
    font_size = 14.0

    desktop_background = "#${colors.base0B}"

    [[rules]]
    match_app_id = "com.mitchellh.ghostty"
    match_props = "toplevel"
    force_ssd = true
  '';
}
