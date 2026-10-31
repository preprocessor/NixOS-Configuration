{
  exo.mods.desktop = {
    my.hyprland.lua.files."layouts.main".content = /* lua */ ''
      hl.config({
      	general = {
      		layout = "dwindle",
      	},

      	layout = {
      		single_window_aspect_ratio = { 16, 9 },
      	},

        dwindle = {
          force_split = 2,
          -- smart_split = true,
          smart_resizing = false,
          preserve_split = true,
          special_scale_factor = 0.95,
          split_width_multiplier = 2.0,
          split_bias = 1,
        },
      })
    '';
  };
}
