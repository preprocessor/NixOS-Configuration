{ lib, ... }:
{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    let
      theme = "everforest";
    in
    {
      xdg.configFile."bat/themes/${theme}.tmTheme".text = lib.readFile ./${theme}.tmTheme;

      programs.bat = {
        enable = true;
        config = {
          theme = "${theme}";
        };
        extraPackages = with pkgs.bat-extras; [
          batman
        ];
      };
    };
}
