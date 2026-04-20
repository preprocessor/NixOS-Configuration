{ lib, ... }:
{
  w.desktop =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        waypaper
        awww
      ];

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

      custom.programs.niri.settings.spawn-at-startup = [ "${lib.getExe pkgs.waypaper} --restore" ];
    };
}
