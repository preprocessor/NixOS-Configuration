{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
  ];

  home.packages = with pkgs; [
    vivaldi
    nixfmt
  ];

  programs.zsh = {
    enable = true;
  };
}
