{
  w.desktop =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        waypaper
        awww
      ];

      custom.programs.niri.settings.spawn-at-startup = [
        "awww-daemon"
        "waypaper --restore"
      ];
    };
}
