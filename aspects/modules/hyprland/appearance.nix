{
  exo.mods.desktop =
    { scheme, ... }:
    with scheme;
    {
      my.hyprland.lua.files."appearance".content = /* lua */ ''
        hl.config({
          general = {
            gaps_in          = 8,
            gaps_out         = 24,

            border_size      = 1,

            col              = {
              active_border   = "rgb(${bright-cyan})",
              inactive_border = "rgb(${base07})",
            },

            layout           = "lua:centercol",
          },

          decoration = {
            active_opacity   = 1.0,

            inactive_opacity = 1.0,

            dim_special = 0.8,

            shadow           = {
              enabled        = true,
              range          = 10,
              render_power   = 4,
              color          = 0x1F${bright-cyan},
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
