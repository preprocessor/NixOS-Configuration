{
  w.desktop = {
    wrappers.hyprland.lua.files."window_rules".content = /* lua */ ''
      hl.window_rule({
        name = "float zathura",
        match = {
          class = "^org.pwmt.zathura$"
        },
        float = true,
      })
    '';

    wrappers.zathura = {
      enable = true;
    };
  };
}
