{
  tack.inputs.hypr-motif.url = "gh:preprocessor/hypr-motif";

  perSystem = { packages', pkgs, ... }: {
    remotePackages.hypr-motif = packages'.hypr-motif.override {
      inherit (pkgs) hyprland;
    };
  };

  exo.mods.desktop =
    { self', ... }:
    {
      my.hyprland.plugins = { inherit (self'.packages) hypr-motif; };

      my.hyprland.lua.files."plugins/motif".content = /* lua */ ''
        hl.on("config.reloaded", function()
          if utils.is_plugin_loaded("cde") then
            hl.config({
              plugin = {
                cde = {
                  color_face = "#333333",
                  color_light = "#555555",
                  color_dark = "#111111",

                  color_face_active = "#336666",
                  color_light_active = "#558888",
                  color_dark_active = "#114444",

                  title_font_size = 14,

                  bar_height = 26,
                },
              },
            })

            hl.window_rule({
              match = { class = "^steam$" },
              ["cde:show_titlebar"] = false,
              ["cde:show_border"] = false,
            })

            hl.window_rule({
              match = { tag = "hidden" },

              ["cde:color_face"] = "#dc7a00",
              ["cde:color_light"] = "#ffdf5f",
              ["cde:color_dark"] = "#884400",

              ["cde:color_face_active"] = "#dd4444",
              ["cde:color_light_active"] = "#ff7777",
              ["cde:color_dark_active"] = "#220000",

              ["cde:color_title"] = "#ffffff",
            })
          end
        end)
      '';
    };
}
