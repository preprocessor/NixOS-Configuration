{
  w.desktop = {
    my.hyprland.lua.files."window_rules.zathura".content = /* lua */ ''
      hl.window_rule({
        name = "float zathura",
        match = {
          class = "^org.pwmt.zathura$"
        },
        float = true,
      })
    '';

    my.zathura = {
      enable = true;
    };
  };
}
