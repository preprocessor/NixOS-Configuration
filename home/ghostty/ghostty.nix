{ ... }:
{
  # xdg.configFile."ghostty/themes/Gruvbox_Light_Soft".source = ./Gruvbox_Light_Soft.toml;

  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    installVimSyntax = true;

    settings = {
      theme = "Batman";

      font-size = "12.5";

      font-family = "Fira Code";
      font-style = "SemiBold";

      font-family-bold = "Fira Code";
      # font-style-bold = "Bold";

      font-family-italic = "Victor Mono";
      font-style-italic = "SemiBold Italic";

      font-family-bold-italic = "Victor Mono";
      # font-style-bold-italic = "Bold Italic";

      #                  │ Victor Mono  │ Fira Code
      font-feature = [
        # ├──────────────┼───────────
        "ss02" # │ Slashed Zero │ Horizontal <= symbols
        "ss06" # │ Slashed 7    │ Lighten first slash in \\
        "ss07" # │ Curved 6 + 9 │ ~= Ligatures
        "ss10" # │ None         │ Combine letters
        # Ligatures
        "calt"
        "liga"
        "dlig"
      ];

      # custom-shader = "${./shaders/starfield-colors.glsl}";
    };
  };
}
