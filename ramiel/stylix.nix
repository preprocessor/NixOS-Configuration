{
  inputs,
  pkgs,
  ...
}:
let
  apple-fonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
  scheme = ./styles/espresso-libre.yaml;
in
{
  scheme = scheme; # Set base16 scheme

  stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = scheme;

    fonts = {
      serif = {
        package = apple-fonts.ny;
        name = "New York";
      };

      sansSerif = {
        package = apple-fonts.sf-pro;
        name = "SF Pro";
      };

      monospace = {
        package = apple-fonts.sf-mono;
        name = "SF Mono Regular";
      };
    };

    targets = {
      console.enable = true;
    };
  };
  # config.home-manager.users.wyspr.stylix = {
  #   targets = {
  #     # neovim.enable = false;
  #     # ghostty.enable = false;
  #     qt.platform = "qtct";
  #   };
  # };
}
