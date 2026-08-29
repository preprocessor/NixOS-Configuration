{
  exo.mods.desktop =
    { lib, pkgs, ... }:
    {
      hj.packages = with pkgs; [
        mako
        libnotify # notify-send
      ];

      my.hyprland.startup = [
        ''hl.exec_cmd("${lib.getExe pkgs.mako}")''
      ];

      my.hyprland.lua.files."layer_rules.mako".content = /* lua */ ''
        hl.layer_rule({
          match        = { namespace = "^notifications$" },
          no_screen_share = true,
          ignore_alpha = 0.3,
          blur         = true,
          blur_popups  = true,
          animation    = "slide right"
        })
      '';
    };
}
