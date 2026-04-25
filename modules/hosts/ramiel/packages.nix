{
  w.ramiel =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        qbittorrent-enhanced
        brightnessctl
        grim
        swaylock
        slurp
        # wlsunset # or gammastep
        wlogout
        overskride
      ];

      hj.packages = with pkgs; [
        vivaldi
        mpv
        qview
        gdmap # similar to WinDirStat
      ];
    };
}
