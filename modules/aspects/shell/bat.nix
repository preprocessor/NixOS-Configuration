{ inputs, ... }:
{
  flake-file.inputs.bat-syntax-justfile = {
    url = "github:nk9/just_sublime";
    flake = false;
  };

  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        bat-extras.batman
        bat
      ];

      hj.xdg.config.files."bat/syntaxes/justfile.sublime-syntax".source =
        "${inputs.bat-syntax-justfile}/Syntax/Just.sublime-syntax";

    };

}
