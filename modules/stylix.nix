{
  inputs,
  pkgs,
  ...
}:
let
  apple-fonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
  scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-soft.yaml";
in
{
  config.scheme = scheme; # Set base16 scheme

  config.stylix = {
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

    };
  };
}
