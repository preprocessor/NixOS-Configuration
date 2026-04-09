{ lib, ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      systemd.user.services.awww-daemon = {
        description = "awww wallpaper daemon";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = lib.getExe' pkgs.awww "awww-daemon";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      environment.systemPackages = [
        pkgs.awww
      ];
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.waypaper
      ];
    };
}
