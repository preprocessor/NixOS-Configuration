{ inputs, ... }:
{
  w.default =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      apple-fonts = inputs.apple-fonts.packages.${pkgs.sys};
      scheme = config.scheme.withHashtag;

      toIni =
        cfg:
        lib.generators.toINIWithGlobalSection { } {
          globalSection = cfg;
        };
    in
    {
      environment.systemPackages = with pkgs; [
        tofi
        bemoji-tofi
      ];

      hj.xdg.config.files = {
        "tofi/config".text = toIni {
          font = "${apple-fonts.sf-pro}/share/fonts/truetype/SF-Pro.ttf";

          padding-left = "35%";
          padding-top = "35%";

          width = "100%";
          height = "100%";
          border-width = 0;
          outline-width = 0;

          result-spacing = 25;
          num-results = 5;

          background-color = "#000A";
          text-color = scheme.base05;
          selection-color = scheme.cyan;
        };

        "tofi/config_bemoji".text = toIni {
          font = "${apple-fonts.sf-pro}/share/fonts/truetype/SF-Pro.ttf";

          padding-left = "1%";
          padding-top = "2%";
          padding-right = "1%";
          padding-bottom = "2%";

          corner-radius = 0;

          border-color = "${scheme.yellow}";
          border-width = 4;

          background-color = "${scheme.base01}";
          text-color = "${scheme.base05}";
          selection-color = "${scheme.yellow}";

          width = 720;
          height = 720;
        };
      };
    };
}
