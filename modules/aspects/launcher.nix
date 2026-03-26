{ inputs, ... }:
{
  flake.modules.homeManager.default =
    { pkgs, osConfig, ... }:
    let
      apple-fonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
      scheme = osConfig.scheme.withHashtag;
    in
    {
      xdg.configFile."tofi/config_bemoji".text = /* ini */ ''
        font = "${apple-fonts.sf-pro}/share/fonts/truetype/SF-Pro.ttf";

        padding-left = 1%
        padding-top = 2%
        padding-right = 1%
        padding-bottom = 2%

        corner-radius = 0

        border-color = ${scheme.yellow}
        border-width = 4

        background-color = ${scheme.base01}
        text-color = ${scheme.base05}
        selection-color = ${scheme.yellow}

        width = 720
        height = 720
      '';

      programs.tofi = {
        enable = true;
        settings = {
          width = "100%";
          height = "100%";
          border-width = 0;
          outline-width = 0;
          padding-left = "35%";
          padding-top = "35%";
          result-spacing = 25;
          num-results = 5;
          font = "${apple-fonts.sf-pro}/share/fonts/truetype/SF-Pro.ttf";
          background-color = "#000A";
          text-color = scheme.base05;
          selection-color = scheme.cyan;
        };
      };
    };
}
