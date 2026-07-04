{
  w.desktop = {
    custom.programs.hyprland.lua.files = {
      "window_rules.tags".content = /* lua */ ''
        hl.window_rule({
          match = { tag = "center-float" },

          stay_focused = true,
          center       = true,
          float        = true,
          pin          = true,
        })
      '';
    };
  };
}
