{
  flake.modules.homeManager.desktop = {
    programs.ghostty = {
      enable = true;
      installBatSyntax = true;
      installVimSyntax = true;

      settings = {
        theme = "Everforest Dark Hard";

        font-size = "12";

        keybind = [
          "ctrl+shift+tab=unbind"
          "ctrl+shift+w=unbind"
        ];

        window-decoration = "none";

        # custom-shader = "${./shaders/animated-gradient-shader.glsl}";
        # custom-shader-animation = "always";

        font-family = "Maple Mono";
        font-style = "Medium";

        font-family-bold = "Maple Mono";
        font-style-bold = "ExtraBold";

        font-family-italic = "Maple Mono";
        font-style-italic = "Italic";

        font-family-bold-italic = "Maple Mono";
        font-style-bold-italic = "Bold Italic";

        font-feature = [
          # test sentences
          # sphinx of black quartz, judge my vow .,;: al il ull 01223456789
          # SPHINX OF BLACK QUARTZ, JUDGE MY VOW
          "sphinx of black quartz, judge my vow .,;:  01223456789"
          "SPHINX OF BLACK QUARTZ, JUDGE MY VOW"
          "calt"
          "cv01"
          "cv02"
          "cv03"
          "cv07"
          "cv09"
          "cv10"

          "cv40"
          "cv42"
          "cv43"

          "ss03"
          "ss10"
        ];

        # fira-victor = {
        #   font-family = "Fira Code";
        #   font-style = "SemiBold";
        #
        #   font-family-bold = "Fira Code";
        #   # font-style-bold = "Bold";
        #
        #   font-family-italic = "Victor Mono";
        #   font-style-italic = "SemiBold Italic";
        #
        #   font-family-bold-italic = "Victor Mono";
        #   # font-style-bold-italic = "Bold Italic";
        #
        #   font-feature = [
        #     #                │ Victor Mono  │ Fira Code
        #     #                ├──────────────┼───────────
        #     "ss02" # .       │ Slashed Zero │ Horizontal <= symbols
        #     "ss06" # .       │ Slashed 7    │ Lighten first slash in \\
        #     "ss07" # .       │ Curved 6 + 9 │ ~= Ligatures
        #     "ss10" # .       │ None         │ Combine letters
        #     # Ligatures
        #     "calt"
        #     "liga"
        #     "dlig"
        #   ];

      };

    };
  };
}
