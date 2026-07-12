{
  w.desktop =
    { pkgs, lib, ... }:
    {
      hj.packages = with pkgs; [
        lutgen-studio
        waypaper
        awww
      ];

      systemd.user.services = {
        wallpaper-daemon = {
          description = "Wallpaper daemon";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            ExecStart = lib.getExe' pkgs.awww "awww-daemon";
            Restart = "on-failure";
          };
        };
      };

      my.hyprland.startup = [
        ''hl.exec_cmd("${lib.getExe pkgs.waypaper} --restore")''
      ];

      my.hyprland.lua.files."window_rules.waypaper".content = /* lua */ ''
        hl.window_rule({
          name = "float waypaper",
          match = {
            class = "^(waypaper)$"
          },
          float = true,
        })
      '';

      _file = "wallpaper.nix";
    };
}
