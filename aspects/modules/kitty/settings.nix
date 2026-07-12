{
  w.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      fonts.packages = with pkgs; [
        maple-mono.variable
        maple-mono.NF
      ];

      hj.xdg.mime-apps.default-applications =
        [
          "inode/directory"
          "terminal"
          "x-terminal-emulator"
          "application/x-shellscript"
        ]
        |> map (mime: lib.nameValuePair mime [ "kitty.desktop" ])
        |> lib.listToAttrs;

      custom.programs.hyprland.startup =
        let
          cfg = config.custom.programs.kitty;
        in
        [
          ''hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "name:dev silent" })''
          ''hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "name:dev silent" })''
        ];

      custom.programs.hyprland.lua.files."keybinds.kitty".content = /* lua */ ''
        hl.bind("SUPER + Return", hl.dsp.exec_raw("kitty -1"), { release = true })

        hl.bind("SUPER + CTRL + Return", hl.dsp.exec_raw("kitty -1"), { float = true, release = true })
      '';

      custom.programs.kitty = {
        settings = {
          # text_composition_strategy = "legacy";
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

          background_opacity = "0.5";

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
