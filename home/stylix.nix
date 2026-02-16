{ config, pkgs, ... }:
{

  # Home level config
  stylix = {
    targets = {
      neovim.enable = false;
      # ghostty.enable = false;
    };
  };
}
