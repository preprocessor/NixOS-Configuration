{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./xdg.nix
    ./zsh.nix
    ./nh.nix
    ./zed.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    virtualbox
    # vesktop
    vivaldi
    nixfmt
    steam
    gimp
  ];
}
