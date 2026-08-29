{
  exo.mods.desktop = {
    my.hyprland.lua.files = {
      "layouts.builtin".content = /* lua */ ''
        hl.config({
          layout = {
            single_window_aspect_ratio = { 16, 9 },
          },

          dwindle = {
            force_split = 2,
            preserve_split = true, -- You probably want this
            smart_split = false,
            smart_resizing = false,
            permanent_direction_override = false,
            split_width_multiplier = 2.0,
            split_bias = 1,
            precise_mouse_move = true,
          },

          scrolling = {
            fullscreen_on_one_column = false,
            explicit_column_widths = "0.25, 0.33333, 0.5, 0.66667, 0.75",
            -- column_width = 0.7296,
            column_width = 0.33333,
            wrap_focus = false,
            wrap_swapcol = false,
          },
        })
      '';
    };
  };
}
