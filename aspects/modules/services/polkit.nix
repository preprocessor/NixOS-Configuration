{
  exo.core =
    { pkgs, ... }:
    {
      security.polkit.enable = true;

      systemd.user.services.polkit-agent = {
        description = "PolicyKit Authentication by Gnome";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      my.hyprland.windowrules.polkit = [
        {
          match.class = "^polkit-gnome-authentication-agent-1$";
          rules = {
            pin = true;
            float = true;
            center = true;
            no_close_for = true;
          };
        }
      ];
    };
}
