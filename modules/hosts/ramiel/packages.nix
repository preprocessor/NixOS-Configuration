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
        imagemagick
        nixos-shell
        trash-cli
        fastfetch
        wlclock
        ripgrep
        rmtrash
        nvim-pkg # neovim
        unzip
        logiops # logitech device controls
        just # a command runner
        wget
        tree
        isd # inspect system d
        btop
        eza # better ls
        zip
        fd # better find
        wl-clipboard
        wl-clip-persist
        cliphist
        wlsunset # or gammastep
        wlogout
        wlprop
        overskride
        dualsensectl
        jq
      ];

      homePackages = with pkgs; [
        # wyspr_waow
        wyspr_eye
        wyspr_gbc
        hand_of_evil
        zide

        waypaper
        gimp
        prismlauncher
        virtualbox
        vivaldi
        delta
      ];
    });
}
