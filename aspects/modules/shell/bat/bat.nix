{ inputs, ... }:
{
  tack.bat-syntax-justfile = {
    url = "gh:nk9/just_sublime";
    type = "fetch";
  };

  exo.mods.desktop =
    { pkgs, ... }:
    {
      hj.xdg.config.files."bat/syntaxes/justfile.sublime-syntax".source =
        "${inputs.bat-syntax-justfile}/Syntax/Just.sublime-syntax";

      hj.packages = with pkgs; [
        bat-extras.batman
        bat
      ];
    };
}
