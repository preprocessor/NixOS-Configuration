{
  exo.mods.desktop =
    { pkgs, ... }:
    {
      my.hyprland.plugins = { inherit (pkgs.hyprlandPlugins) hypr-dynamic-cursors; };

      my.hyprland.lua.files."plugins/dynamic-cursors".content = /* lua */ ''
        hl.on("config.reloaded", function()
          if hl.plugin.dynamic_cursors then
            hl.bind("SUPER + Tab", function()
              hl.plugin.scrolloverview.overview("toggle all")
            end)

            hl.config({
              plugin = {
                scrolloverview = {
                  workspace_gap = 100,
                  wallpaper = 2,
                  blur = true,
                  shadow = {
                    enabled = true,
                  },
                },
              },
            })
          end
        end)
      '';
    };
}
