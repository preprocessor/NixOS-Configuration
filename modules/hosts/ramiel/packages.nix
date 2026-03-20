{ self, ... }:
{
  flake.modules.nixos.ramiel =
    { pkgs, ... }:
    let
      inherit (self.lib) mkPackages;
    in
    (mkPackages {
      nixosPackages = with pkgs; [
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

      homePackages = with pkgs; [
        virtualbox
        vivaldi
        delta
      ];
    });
}
