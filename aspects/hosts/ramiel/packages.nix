{
  w.ramiel =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        brightnessctl
        # wlsunset # or gammastep
      ];

      hj.packages = with pkgs; [
        vivaldi
        gdmap # similar to WinDirStat
        mpv
      ];
    };
}
