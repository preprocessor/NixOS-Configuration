{
  w.desktop =
    { pkgs, ... }:
    let
      niri-shaders-collection = pkgs.fetchFromGitHub {
        owner = "jgarza9788";
        repo = "niri-animation-collection";
        rev = "aa26f4e157b818630cb281f6e1968b641c079d69";
        hash = "sha256-DgoudR6etn+t5eYplPcOISPuWMRAulW6ZOCTsyFHi2w=";
      };
    in
    {
      custom.programs.niri.settings.extraConfig =
        ''include "${niri-shaders-collection}/animations/glide.kdl"'';
    };
}
