{ inputs, ... }:
{
  flake-file.inputs = {
    ghostty.url = "github:ghostty-org/ghostty";
    ghostty-cursor-shaders = {
      url = "github:sahaj-b/ghostty-cursor-shaders";
      flake = false;
    };
    ghostty-shaders = {
      url = "github:0xhckr/ghostty-shaders";
      flake = false;
    };
  };

  flake.modules.nixos.desktop.nixpkgs.overlays = [ inputs.ghostty.overlays.default ];

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      nix.settings = {
        extra-substituters = [ "https://ghostty.cachix.org" ];
        extra-trusted-public-keys = [ "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns=" ];
      };

      programs.ghostty = {
        enable = true;
        installBatSyntax = true;
        installVimSyntax = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        systemd.enable = true;

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

            "ctrl+backslash=new_split:down"
            "chain=resize_split:down,400"

            "maps/v=new_split:right"
            "maps/s=new_split:down"
            "chain=resize_split:down,400"

            "performable:maps/h=goto_split:left"
            "performable:maps/j=goto_split:down"
            "performable:maps/k=goto_split:up"
            "performable:maps/l=goto_split:right"

            "maps/ctrl+h=resize_split:left,10"
            "maps/ctrl+j=resize_split:down,10"
            "maps/ctrl+k=resize_split:up,10"
            "maps/ctrl+l=resize_split:right,10"

            "maps/ctrl+shift+h=resize_split:left,50"
            "maps/ctrl+shift+j=resize_split:down,50"
            "maps/ctrl+shift+k=resize_split:up,50"
            "maps/ctrl+shift+l=resize_split:right,50"

            "performable:ctrl+shift+h=goto_split:left"
            "performable:ctrl+shift+j=goto_split:bottom"
            "performable:ctrl+shift+k=goto_split:top"
            "performable:ctrl+shift+l=goto_split:right"
          ];

          mouse-scroll-multiplier = "1";
          mouse-hide-while-typing = true;
          unfocused-split-opacity = 0.8;

          window-decoration = false;
          window-padding-balance = true;
          window-save-state = "always";

          background-blur = 10;
          background-opacity = 0.85;
          background-opacity-cells = true;

          shell-integration = "fish";

          custom-shader-animation = "always";

          custom-shader = "${inputs.ghostty-cursor-shaders}/cursor_tail.glsl";

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
