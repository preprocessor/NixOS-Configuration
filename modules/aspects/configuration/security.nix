{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      # Whether to enable the RealtimeKit system service, which hands out realtime scheduling priority to user processes on demand. For example, PulseAudio and PipeWire use this to acquire realtime priority.
      security.rtkit.enable = true;
      security.pam.services.ly.enableGnomeKeyring = true;

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
