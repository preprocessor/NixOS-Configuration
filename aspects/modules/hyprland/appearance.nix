{
  w.desktop = {
    custom.programs.hyprland.lua.files."appearance".content = /* lua */ ''
      hl.config({
        general = {
          gaps_in          = 15,
          gaps_out         = 25,

          border_size      = 1,

          col              = {
            active_border   = { colors = { "rgb(EC7420)", "rgb(fabd2f)" }, angle = 135 },
            inactive_border = "rgb(aaaaaa)",
          },

          layout           = "lua:centercol",
        },

        decoration = {
          -- Change transparency of focused and unfocused windows
          active_opacity   = 1.0,

          inactive_opacity = 1.0,

          dim_special = 0.8,

          shadow           = {
            enabled        = true,
            range          = 15,
            render_power   = 4,
            color          = 0x0cEC7420,
            color_inactive = 0x00000000,
          },

          blur             = {
            enabled  = true,
            size     = 6,
            passes   = 2,
            vibrancy = 0.1696,
          },
        },
      })
    '';
  };
}
