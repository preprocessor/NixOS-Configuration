{
  exo.mods.desktop = {
    my.hyprland.lua.files."appearance".content = /* lua */ ''
      hl.config({
        general = {
          gaps_in     = 0,
          gaps_out    = 0,
          border_size = 0,
        },

        decoration = {
          dim_special = 0.8,

          shadow = {
            enabled = true,
            offset = { 6, 6 },
            range = 40,
            scale = 0.98,
            render_power = 4,
            color = "0x88000000",
            color_inactive = "0x64111111",
          },

          blur = {
            enabled = false,
          },
        },
      })
    '';
  };
}
