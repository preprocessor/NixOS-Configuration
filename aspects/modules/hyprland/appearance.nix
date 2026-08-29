{
  exo.mods.desktop =
    { scheme, theme, ... }:
    with scheme;
    let
      active = if (theme == "light") then bright-cyan else base05;
      inactive = if (theme == "light") then base07 else base04;
    in
    {
      my.hyprland.lua.files."appearance".content = /* lua */ ''
        hl.config({
          general = {
            gaps_in          = 8,
            gaps_out         = 24,

            border_size      = 1,

            col              = {
              active_border   = "rgb(${active})",
              inactive_border = "rgb(${inactive})",
            },

            layout           = "scrolling",
          },

          decoration = {
            active_opacity   = 1.0,

            inactive_opacity = 1.0,

            dim_special = 0.8,

            shadow           = {
              enabled        = true,
              range          = 10,
              render_power   = 4,
              color          = 0x1F${active},
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
