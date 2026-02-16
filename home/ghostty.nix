{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    installVimSyntax = true;

    settings = {
      # theme = "Everforest Light Medium";
      custom-shader = "${builtins.fetchurl {
        url = "https://raw.githubusercontent.com/hackr-sh/ghostty-shaders/cb6eb4b0d1a3101c869c62e458b25a826f9dcde3/cursor_blaze.glsl";
        sha256 = "sha256:0g2lgqjdrn3c51glry7x2z30y7ml0y61arl5ykmf4yj0p85s5f41";
      }}";
    };
  };
}
