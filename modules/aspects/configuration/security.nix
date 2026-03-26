{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      security = {
        sudo.enable = false;
        sudo-rs = {
          enable = true;
          wheelNeedsPassword = true;
          execWheelOnly = true;
          extraConfig = ''
            Defaults pwfeedback
          '';
        };

        # Whether to enable the RealtimeKit system service, which hands out realtime scheduling priority to user processes on demand. For example, PulseAudio and PipeWire use this to acquire realtime priority.
        rtkit.enable = true;
        polkit.enable = true;
        pam.services.ly.enableGnomeKeyring = true;
        pam.services.swaylock = { };
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
    };
}
