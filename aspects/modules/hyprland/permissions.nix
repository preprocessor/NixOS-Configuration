{
  exo.mods.desktop =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      my.hyprland.lua.files."permissions".content = /* lua */ ''
        hl.config({
          ecosystem = { enforce_permissions = true },
        })

        hl.permission({ binary = "${lib.getExe pkgs.grim}", type = "screencopy", mode = "allow" })
        hl.permission({ binary = "${lib.getExe pkgs.wayfreeze}", type = "screencopy", mode = "allow" })
        hl.permission({ binary = "${lib.getExe config.my.vesktop.package}", type = "screencopy", mode = "allow" })
        hl.permission({ binary = "${pkgs.xdg-desktop-portal-hyprland}/libexec/.xdg-desktop-portal-hyprland-wrapped", type = "screencopy", mode = "allow" })
      '';
    };
}
