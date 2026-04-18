{
  flake.modules.nixos.ramiel =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        qbittorrent-enhanced
        xwayland-satellite
        brightnessctl
        grim
        swaylock
        slurp
        wl-clipboard
        wl-clip-persist
        cliphist
        # wlsunset # or gammastep
        wlogout
        overskride

      ];

      hj.packages = with pkgs; [
        vivaldi
        virtualbox
        mpv
        qview
      ];
    };
}
