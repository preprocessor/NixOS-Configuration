{
  exo.mods.desktop = {
    my.hyprland.lua.files = {
      "layouts.builtin".content = /* lua */ ''
        hl.config({
          layout = {
            single_window_aspect_ratio = { 16, 9 },
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
