{
  exo.mods.desktop =
    { pkgs, ... }:
    {
      my.gtk = {
        enable = true;

        theme = {
          name = "Gruvbox-Yellow-Dark";
          package = pkgs.gruvbox-dark-gtk;
        };

        icons = {
          name = "Tela-orange-dark";
          package = pkgs.tela-icon-theme;
        };
      };

      _file = ./wyspr.nix;
    };
}
