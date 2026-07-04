{
  w.desktop = {
    custom.programs.hyprland.lua.files = {
      "layouts.builtin".content = /* lua */ ''
        hl.config({
          dwindle = {
            preserve_split = true, -- You probably want this
            force_split = 2,
            split_width_multiplier = 2.0,
            split_bias = 1,
            precise_mouse_move = true,
          },

          scrolling = {
            fullscreen_on_one_column = true,
            explicit_column_widths = "0.25, 0.333, 0.5, 0.667, 0.75, 1.0",
            wrap_focus = false,
            wrap_swapcol = false,
          },
        })
      '';
    };
  };
}
