{ config }:
{
  xdg.configFile."canoe/canoe.toml".source = ''
    launcher_cmd = "vicinae"
    terminal_cmd = "ghostty"

    [ui]
    border_width = 10
    border_active = { outer = "#FFD000", mid = "#000000", inner = "#FFD000" }
    border_inactive = { outer = "#000000", mid = "#000000", inner = "#000000" }
    titlebar_text_active = "#000000"
    titlebar_text_inactive = "#808080"
    titlebar_bg_active = "#FFD000"
    titlebar_bg_inactive = "#202020"
    menu_bg = "#000000"
    menu_text = "#FFFFFF"
    menu_highlight_bg = "#FFD000"
    menu_highlight_text = "#000000"
    button_bg = "#202020"
    button_highlight = "#FFD000"
    button_shadow = "#000000"
    font_name = "New York"
    font_size = 12.0
    desktop_background = "#101010"
  '';

}
