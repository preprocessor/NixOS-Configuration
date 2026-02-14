{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./xdg.nix
    ./zsh.nix
    ./nh.nix
    ./zed.nix
    ./ghostty.nix
    ./neovim.nix
    ./nixcord.nix
  ];

  home.packages = with pkgs; [
    virtualbox
    vivaldi
    nixfmt
    steam
    gimp
  ];
}
