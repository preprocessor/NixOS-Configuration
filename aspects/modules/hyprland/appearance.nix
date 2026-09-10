{
  exo.mods.desktop =
    { scheme, theme, ... }:
    with scheme;
    let
      active = bright-cyan;
      inactive = if (theme == "light") then base07 else base00;
    in
    {
      my.hyprland.lua.files."appearance".content = /* lua */ ''
        hl.config({
          general = {
            gaps_in     = 12,
            gaps_out    = 24,
            border_size = 3,

            col = {
              active_border   = "0xFF${active}",
              inactive_border = "0xFF111111",
            },
          },

          decoration = {
            dim_special = 0.8,

            shadow           = {
              enabled        = true,
              range          = 10,
              render_power   = 4,
              color          = 0x8F000000,
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
