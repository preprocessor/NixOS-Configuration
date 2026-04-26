{
  w.desktop = {
    custom.programs.kitty = {
      settings = {
        text_composition_strategy = "legacy";
        font_family = ''family="Maple Mono NF" style="Medium"'';
        bold_font = ''family="Maple Mono NF" style="ExtraBold"'';
        italic_font = ''family="Maple Mono NF" style="Italic"'';
        bold_italic_font = ''family="Maple Mono NF" style="ExtraBold Italic"'';
        font_size = "14";

        disable_ligatures = "cursor";

        wayland_enable_ime = "no";

        sync_to_monitor = "yes";
        remember_window_position = "no";

        draw_minimal_borders = "yes";
        placement_strategy = "center";
        update_check_interval = "24";
        allow_hyperlinks = "yes";

        scrollback_lines = "10000";
        wheel_scroll_multiplier = "5.0";

        strip_trailing_spaces = "smart";
        hide_window_decorations = "yes";

        enable_audio_bell = "no";
        visual_bell_duration = "0.0";
        repaint_delay = "10";

        confirm_os_window_close = "0";

        cursor_trail = "1";
        cursor_trail_decay = "0.1 0.2";
        cursor_shape = "block";
        cursor_blink_interval = "0.5";
        cursor_stop_blinking_after = "15.0";
        enabled_layouts = "splits,stack";

        # Better URL handling
        detect_urls = "yes";
        url_style = "curly";
        # Match foot's "hide cursor when typing"
        mouse_hide_wait = "2.0";

        # Match foot's hollow cursor when unfocused
        focus_follows_mouse = "no"; # if you don't already have FFM
        cursor_shape_unfocused = "hollow"; # kitty 0.36+
      };

      keybindings = {
        # Splits
        "ctrl+shift+|" = "launch --location=vsplit";
        "ctrl+|" = "combine : launch --location=hsplit : resize_window shorter 10";
        "ctrl+n" = "launch --location=vsplit";
        # Navigation with Alt + arrows
        "alt+left" = "neighboring_window left";
        "alt+right" = "neighboring_window right";
        "alt+up" = "neighboring_window up";
        "alt+down" = "neighboring_window down";

        "ctrl+x" = "close_window";
      };

      extraConfig = # toml
        let
          font-features = "+cv01 +cv06 +cv09 +cv10 +cv11 +cv31 +cv38 +cv40 +cv42 +cv43 +cv64 +cv66 +ss03 +ss07 +ss08 +ss09 +ss10 +ss11 +calt";
        in
        ''
          font_features MapleMono-NF-Bold ${font-features}
          font_features MapleMono-NF-ExtraBold ${font-features}
          font_features MapleMono-NF-BoldItalic ${font-features}
          font_features MapleMono-NF-ExtraBoldItalic ${font-features}
          mouse_map right press ungrabbed combine : copy_to_clipboard : clear_selection
          mouse_map left press ungrabbed mouse_selection drag_or_normal_select
        '';
    };
  };
}
