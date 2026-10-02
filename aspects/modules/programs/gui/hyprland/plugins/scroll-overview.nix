{
  tack.inputs.hyprland-scroll-overview.url = "gh:yayuuu/hyprland-scroll-overview";

  exo.mods.desktop =
    { packages', ... }:
    {
      my.hyprland.plugins = { inherit (packages') hyprland-scroll-overview; };

      my.hyprland.lua.files."plugins/scrolloverview".content = /* lua */ ''
        hl.on("config.reloaded", function()
          if hl.plugins.scrolloverview then
            hl.config({
              plugin = {
                dynamic_cursors = {
                  mode = "rotate"
                },
              },
            })
          end
        end)
      '';
    };
}
