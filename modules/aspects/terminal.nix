{ inputs, ... }:
{
  flake-file.inputs.ghostty-shaders = {
    url = "github:sahaj-b/ghostty-cursor-shaders";
    flake = false;
  };

  flake.modules.homeManager.desktop = {
    programs.ghostty = {
      enable = true;
      installBatSyntax = true;
      installVimSyntax = true;

      settings = {
        font-size = "12";

        keybind = [
          "ctrl+shift+tab=unbind"
          "ctrl+shift+w=unbind"

          "ctrl+space=activate_key_table_once:maps"
          "ctrl+shift+space=activate_key_table:maps"

          "maps/ctrl+space=deactivate_key_table"
          "maps/ctrl+shift+space=deactivate_key_table"
          "maps/escape=deactivate_key_table"

          "maps/ctrl+x=close_surface"
          "maps/ctrl+q=close_window"

          "maps/s=new_split:right"
          "maps/v=new_split:down"

          "maps/h=goto_split:left"
          "maps/j=goto_split:down"
          "maps/k=goto_split:up"
          "maps/l=goto_split:right"

          "maps/ctrl+h=resize_split:left,10"
          "maps/ctrl+j=resize_split:down,10"
          "maps/ctrl+k=resize_split:up,10"
          "maps/ctrl+l=resize_split:right,10"

          "maps/ctrl+shift+h=resize_split:left,50"
          "maps/ctrl+shift+j=resize_split:down,50"
          "maps/ctrl+shift+k=resize_split:up,50"
          "maps/ctrl+shift+l=resize_split:right,50"

        ];

        mouse-scroll-multiplier = "1";

        unfocused-split-opacity = 0.9;

        window-decoration = "none";
        window-padding-balance = true;
        window-save-state = "always";

        shell-integration = "fish";

        custom-shader = "${inputs.ghostty-shaders}/cursor_warp.glsl";
        custom-shader-animation = "always";

        font-family = "Maple Mono";
        font-style = "Medium";

        font-family-bold = "Maple Mono";
        font-style-bold = "ExtraBold";

        font-family-italic = "Maple Mono";
        font-style-italic = "Italic";

        font-family-bold-italic = "Maple Mono";
        font-style-bold-italic = "Bold Italic";

        font-feature = [
          # some test sentences
          # sphinx of black quartz, judge my vow .,;: al il ull 01223456789
          # SPHINX OF BLACK QUARTZ, JUDGE MY VOW
          # "sphinx of black quartz, judge my vow .,;:  01223456789"
          # "SPHINX OF BLACK QUARTZ, JUDGE MY VOW"
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
      };
    };
  };
}
