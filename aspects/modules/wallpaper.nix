{
  w.desktop =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        gowall
        waypaper
        awww
      ];

      wrappers.niri.settings.spawn-at-startup = [
        "awww-daemon"
        [
          "waypaper"
          "--restore"
        ]
      ];

      _file = "wallpaper.nix";
    };
}
