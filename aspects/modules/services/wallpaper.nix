{
  exo.mods.desktop = { pkgs, lib, ... }: {
    hj.packages = with pkgs; [
      lutgen-studio
      hyprpaper
      wpgtk
    ];

    hj.systemd.services.wallpaper-daemon = {
      description = "Wallpaper daemon";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig.Restart = "on-failure";
      script = lib.getExe pkgs.hyprpaper;
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
