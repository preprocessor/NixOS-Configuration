{
  w.base16 =
    { scheme, ... }:
    {
      custom.programs.ghostty = {
        settings.theme = "stylix";
        themes.stylix = with scheme.withHashtag; {

          background = scheme.base00;
          foreground = scheme.base05;
          cursor-color = scheme.base05;
          selection-background = scheme.base02;
          selection-foreground = scheme.base05;

          palette = [
            "0=${base00}"
            "1=${base08}"
            "2=${base0B}"
            "3=${base0A}"
            "4=${base0D}"
            "5=${base0E}"
            "6=${base0C}"
            "7=${base05}"
            "8=${base03}"
            "9=${base08}"
            "10=${base0B}"
            "11=${base0A}"
            "12=${base0D}"
            "13=${base0E}"
            "14=${base0C}"
            "15=${base07}"
          ];
        };
      };
    };
}
