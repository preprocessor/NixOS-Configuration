{ inputs, ... }:
{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    let
      apple-fonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
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
        };
      };
    };
}
