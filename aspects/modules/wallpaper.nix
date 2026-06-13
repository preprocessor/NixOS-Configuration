{
  w.desktop =
    { pkgs, ... }:
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
            ExecStart = "${pkgs.awww}/bin/awww-daemon";
            Restart = "on-failure";
          };
        };

        wallpaper-restore = {
          description = "Waytrogen";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.waypaper}/bin/waypaper --restore";
            Type = "oneshot";
          };
        };
      };

      wrappers.hyprland.startup = [
        "${pkgs.waypaper}/bin/waypaper --restore"
      ];

      wrappers.hyprland.lua.files."window_rules".content = /* lua */ ''
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
