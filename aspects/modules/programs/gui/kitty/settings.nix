{
  exo.mods.desktop = { scheme, ... }: {
    my.kitty = {
      enable = true;

      settings = {
        font_family = ''family="Maple Mono NF" style="Medium"'';
        bold_font = ''family="Maple Mono NF" style="ExtraBold"'';
        italic_font = ''family="Maple Mono NF" style="Italic"'';
        bold_italic_font = ''family="Maple Mono NF" style="ExtraBold Italic"'';
        font_size = "14.5";

        resize_debounce_time = "0 0";

        disable_ligatures = "cursor";

        wayland_enable_ime = "no";

        remember_window_position = "no";

        draw_minimal_borders = "yes";
        update_check_interval = "0";
        allow_hyperlinks = "yes";

        shell_integration = "no-cursor";

        background_opacity = "0.95";

        scrollback_lines = "10000";
        wheel_scroll_multiplier = "5.0";

        strip_trailing_spaces = "smart";
        hide_window_decorations = "yes";

        enable_audio_bell = "no";
        visual_bell_duration = "0.0";

        confirm_os_window_close = "0";

        cursor = "none";
        cursor_trail = "1";
        cursor_trail_decay = "0.1 0.2";
        cursor_shape = "block";
        cursor_blink_interval = "0.5 ease-in-out";
        cursor_stop_blinking_after = "0.0";
        enabled_layouts = "splits,stack";

        detect_urls = "yes";
        url_style = "curly";
        mouse_hide_wait = "2.0";

        focus_follows_mouse = "no";
        cursor_shape_unfocused = "hollow";
      };

      theme = with scheme; ''
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

      keybindings = {
        # Splits
        "ctrl+shift+\\" = "launch --cwd=current --location=vsplit";
        "ctrl+\\" = "combine : launch --cwd=current --location=hsplit : layout_action bias 25";
        "ctrl+n" = "launch --cwd=current --location=vsplit";
        # Navigation with Alt + arrows
        "alt+left" = "neighboring_window left";
        "alt+right" = "neighboring_window right";
        "alt+up" = "neighboring_window up";
        "alt+down" = "neighboring_window down";
        # Navigation with Ctrl + Shift + {h, j, k, l}
        "ctrl+shift+h" = "neighboring_window left";
        "ctrl+shift+l" = "neighboring_window right";
        "ctrl+shift+k" = "neighboring_window up";
        "ctrl+shift+j" = "neighboring_window down";
      };

      extraCfg =
        let
          font-features = "+cv01 +cv02 +cv03 +cv09 +cv10 +cv38 +cv40 +cv41 +cv42 +cv43 +cv64 +cv66 +ss03 +ss07 +ss08 +ss09 +ss10 +ss11";
        in
        ''
          font_features MapleMono-NF-Medium ${font-features}
          font_features MapleMono-NF-ExtraBold ${font-features}
          font_features MapleMono-NF-Italic ${font-features}
          font_features MapleMono-NF-ExtraBoldItalic ${font-features}
          mouse_map right press ungrabbed combine : copy_to_clipboard : clear_selection
          mouse_map left press ungrabbed mouse_selection drag_or_normal_select

          env TERMINAL=kitty
        '';
    };
  };

}
