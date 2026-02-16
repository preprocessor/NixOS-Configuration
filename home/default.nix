{ inputs, config, pkgs, ... }:
{
  imports = [
    ./ghostty.nix
    ./git.nix
    ./neovim.nix
    ./nh.nix
    ./nixcord.nix
    ./shell.nix
    ./stylix.nix
    ./xdg.nix
    ./zed.nix
  ];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    inputs.helium.packages.${pkgs.system}.default
    prismlauncher
    virtualbox
    vivaldi
    steam
    gimp
  ];
}
