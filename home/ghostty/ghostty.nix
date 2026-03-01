{ ... }:
{
  xdg.configFile."ghostty/themes/Gruvbox_Light_Soft".source = ./Gruvbox_Light_Soft.toml;
  xdg.configFile."ghostty/themes/Everforest_Light_Soft".source = ./Everforest_Light_Soft.yaml;

  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    installVimSyntax = true;

    settings = {
      theme = "Gruvbox_Light_Soft";

      font-size = "12";

      font-family = "Fira Code";
      font-style = "SemiBold";

      font-family-bold = "Fira Code";
      # font-style-bold = "Bold";

      font-family-italic = "Victor Mono";
      font-style-italic = "SemiBold Italic";

      font-family-bold-italic = "Victor Mono";
      # font-style-bold-italic = "Bold Italic";

      font-feature = [
        #                │ Victor Mono  │ Fira Code
        #                ├──────────────┼───────────
        "ss02" # .       │ Slashed Zero │ Horizontal <= symbols
        "ss06" # .       │ Slashed 7    │ Lighten first slash in \\
        "ss07" # .       │ Curved 6 + 9 │ ~= Ligatures
        "ss10" # .       │ None         │ Combine letters
        # Ligatures
        "calt"
        "liga"
        "dlig"
      ];

      custom-shader = "${./shaders/starfield-colors.glsl}";
      custom-shader-animation = "always";
    };
  };
}
