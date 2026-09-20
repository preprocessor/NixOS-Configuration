{
  exo.skeleton =
    { scheme, ... }:
    {
      my.kitty.theme = with scheme.withHashtag; ''
        background ${base11}
        foreground ${base05}
        selection_background ${base05}
        selection_foreground ${base00}
        url_color ${base04}
        cursor ${base05}
        cursor_text_color ${base00}
        active_border_color ${base03}
        inactive_border_color ${base01}
        active_tab_background ${base00}
        active_tab_foreground ${base05}
        inactive_tab_background ${base01}
        inactive_tab_foreground ${base04}
        tab_bar_background ${base01}
        wayland_titlebar_color ${base00}
        macos_titlebar_color ${base00}

        # normal
        color0   ${base00}
        color1   ${red}
        color2   ${green}
        color3   ${yellow}
        color4   ${blue}
        color5   ${magenta}
        color6   ${cyan}
        color7   ${base02}

        # bright
        color8   ${base01}
        color9   ${bright-red}
        color10  ${bright-green}
        color11  ${bright-yellow}
        color12  ${bright-cyan}
        color13  ${bright-blue}
        color14  ${bright-magenta}
        color15  ${base04}

        # extended base16 colors
        color16  ${orange}
        color17  ${brown}
        color18  ${base01}
        color19  ${base03}
        color20  ${base04}
        color21  ${base06}
      '';

    };
}
