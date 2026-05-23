{
  w.default =
    { pkgs, ... }:
    let
      bat-syntax-justfile = pkgs.fetchFromGitHub {
        owner = "nk9";
        repo = "just_sublime";
        rev = "2dcc60286d1af6a4c6c2c03d50bc03230dc56ce3";
        hash = "sha256-XlxItYVL9I612DhfCGHiUdv6U6Nv9LOlEbJVf1zTwPg=";
      };
    in
    {
      hj.packages = with pkgs; [
        bat-extras.batman
        bat
      ];

      hj.xdg.config.files."bat/syntaxes/justfile.sublime-syntax".source =
        "${bat-syntax-justfile}/Syntax/Just.sublime-syntax";
    };
}
