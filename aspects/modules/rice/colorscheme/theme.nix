{
  w.wyspr-theme =
    { pkgs, ... }:
    {
      custom.gtk = {
        enable = true;

        theme = {
          name = "Gruvbox-Yellow-Dark";
          package = pkgs.gruvbox-gtk-theme.override {
            colorVariants = [ "dark" ];
            # sizeVariants = [ "compact" ];
            themeVariants = [ "yellow" ];
          };
        };

        icons = {
          name = "Tela-orange-dark";
          package = pkgs.tela-icon-theme;
        };
      };

      _file = ./wyspr.nix;
    };
}
