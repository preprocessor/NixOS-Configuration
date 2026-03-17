{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.vicinae
      ];

      # systemd.user.services.vicinae-agent = {
      #   description = "Vicinae";
      #   wantedBy = [ "graphical-session.target" ];
      #   after = [ "graphical-session.target" ];
      #   partOf = [ "graphical-session.target" ];
      #   environment = {
      #     USE_LAYER_SHELL = 1;
      #     PATH = "/etc/profiles/per-user/wyspr/bin:/run/current-system/sw/bin";
      #   };
      #   serviceConfig = {
      #     Type = "simple";
      #     ExecStart = "${pkgs.vicinae}/bin/vicinae server";
      #     Restart = "on-failure";
      #     RestartSec = 1;
      #     TimeoutStopSec = 10;
      #     KillMode = "process";
      #   };
      # };
    };
}
