{
  exo.core =
    { pkgs, ... }:
    {
      security = {
        sudo.enable = false;
        run0 = {
          enable = true;
          sudo-shim.enable = true;
          persistentAuth.enable = true;
        };
        # Whether to enable the RealtimeKit system service, which hands out realtime scheduling priority to user processes on demand. For example, PulseAudio and PipeWire use this to acquire realtime priority.
        rtkit.enable = true;
        polkit.enable = true;
      };
      services.gnome.gnome-keyring.enable = true; # secret service

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
