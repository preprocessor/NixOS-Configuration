{
  exo.mods.desktop =
    { lib, pkgs, ... }:
    {
      hj.packages = with pkgs; [
        libnotify # notify-send
        mako
      ];

      hj.systemd.services.notification-daemon = {
        description = "mako notification daemon";
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig.Restart = "on-failure";
        script = lib.getExe pkgs.mako;
      };

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
