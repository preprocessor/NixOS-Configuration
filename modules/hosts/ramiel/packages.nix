{
  w.ramiel =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        qbittorrent-enhanced
        brightnessctl
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
