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

      })
    '';
  };
}
