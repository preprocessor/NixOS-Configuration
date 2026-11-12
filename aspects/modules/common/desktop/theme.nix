{
  modules.host.ramiel =
    { pkgs, ... }:
    {
      my.gtk = {
        enable = true;

        theme = {
          name = "gruvbox-dark";
          package = pkgs.gruvbox-dark-gtk;
        };

        icons = {
          name = "Tela-orange-dark";
          package = pkgs.tela-icon-theme;
        };
      };
    };
}
