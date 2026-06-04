{
  envoy = {
    retrowave-light-kitty.url = "https://raw.githubusercontent.com/BrokenSideViewMirror/kitty-themes/refs/heads/master/themes/retrowave-light.conf";
  };

  w.wyspr-theme =
    {
      config,
      scheme,
      envoy,
      pkgs,
      lib,
      ...
    }:
    {
      # hj.xdg.config.files = {
      #   "eza/theme.yml".source = envoy.eza-themes.src + "/themes/gruvbox-dark.yml";
      #   "lazygit/config.yml".text =
      #     builtins.readFile "${envoy.gruvbox-lazygit.src}/themes/dark_hard_original.yml";
      # };

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
