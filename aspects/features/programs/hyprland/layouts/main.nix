{
  modules.features.desktop = {
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
          smart_resizing = false,
          preserve_split = true,
          split_width_multiplier = 2.0,
          split_bias = 1,
        },
      })
    '';
  };
}
