{
  exo.mods.desktop =
    { pkgs, lib, ... }:
    {
      hj.packages = with pkgs; [
        lutgen-studio
        waypaper
        wpgtk
        awww
      ];

      hj.systemd.services = {
        wallpaper-daemon = {
          description = "Wallpaper daemon";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];
          serviceConfig.Restart = "on-failure";
          script = lib.getExe' pkgs.awww "awww-daemon";
        };

        restore-wallpaper = {
          description = "Restore wallpaper";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          serviceConfig.Type = "oneshot";
          path = [
            pkgs.procps
            pkgs.awww
          ];
          script = "${lib.getExe pkgs.waypaper} --restore";
        };
      };

      my.hyprland.windowrules.waypaper = [
        {
          name = "float waypaper";
          match.class = "^(waypaper)$";
          rules.float = true;
        }
      ];

      _file = "wallpaper.nix";
    };
}
