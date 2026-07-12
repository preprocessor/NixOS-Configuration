{
  w.desktop = {
    my.hyprland.lua.files."animations".content = /* lua */ ''
      hl.config({
        animations = {
          enabled = true,
        },
      })

      hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })
      hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
      hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
      hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
      hl.curve("slow", { type = "bezier", points = { { 0, 0.85 }, { 0.3, 1 } } })
      hl.curve("overshot", { type = "bezier", points = { { 0.7, 0.6 }, { 0.1, 1.1 } } })
      hl.curve("bounce", { type = "bezier", points = { { 1.1, 1.6 }, { 0.1, 0.85 } } })
      hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
      hl.curve("smoothIn", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })

      hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
      hl.curve("easeOutQuad", { type = "bezier", points = { { 0.5, 1.0 }, { 0.89, 1.0 } } })

      hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1.0 } } })
      hl.curve("border_angle", { type = "bezier", points = { { 0.25, 0 }, { 1, 1 } } })

      hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "easeOutExpo", style = "gnomed" })

      hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.5, bezier = "slow", style = "slide" })

      hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "linear" })
      hl.animation({ leaf = "borderangle", enabled = true, speed = 20, bezier = "border_angle" })

      hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "slow" })

      hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "easeInOutCubic", style = "fade" })

      hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 3, bezier = "smoothIn", style = "slide top" })
      hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 3, bezier = "easeOutQuad", style = "slide bottom" })
    '';
  };
}
