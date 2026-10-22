{
  exo.mods.desktop =
    { scheme, ... }:
    {
      my.hyprland.lua.files."appearance".content = /* lua */ ''
        hl.config({
          general = {
            gaps_in     = 0,
            gaps_out    = 0,
            border_size = 0,

            col = {
              active_border   = "0xFF${scheme.noHashtag.bright-cyan}",
              inactive_border = "0xFF111111",
            },
          },

          decoration = {
            dim_special = 0.8,

            shadow           = {
              enabled        = false,
              range          = 10,
              render_power   = 4,
              color          = 0x8F000000,
              color_inactive = 0x00000000,
            },

            blur = {
              enabled = false,
              size = 10,
              passes = 4,
              noise = 0.03,
            },
          },
        })
      '';
    };
}
