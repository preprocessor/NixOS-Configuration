{
  w.ramiel =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        qbittorrent-enhanced
        brightnessctl
        overskride
        swaylock
        # wlsunset # or gammastep
        wlogout
        typora
        slurp
        grim
      ];

      hj.packages = with pkgs; [
        vivaldi
        qview
        gdmap # similar to WinDirStat
        mpv
      ];
    };
}
