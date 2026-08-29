{
  exo.mods.desktop = {
    my.hyprland.lua.files = {
      "keybinds.overview".content = /* lua */ ''
        -- switch/cycle layouts
        hl.bind("SUPER + N", function()
          utils.layout_cycle({
            ["dwindle"] = "scrolling",
            ["scrolling"] = "dwindle",
          })
        end)

        hl.bind("SUPER + SHIFT + N", function()
          utils.layout_cycle({
            ["scrolling"] = "dwindle",
            ["dwindle"] = "scrolling",
          })
        end)
      '';
    };
  };
}
