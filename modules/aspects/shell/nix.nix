{ ... }:
{
  w.default =
    { pkgs, ... }:
    {
      nix.package = pkgs.nix.overrideAttrs (o: {
        src = pkgs.fetchFromGitHub {
          owner = "NixOS";
          repo = "nix";
          rev = "lazy-store-paths-for-flakes";
          hash = "sha256-YLID5rJRUJCg0NNPDYippJSTntmQ9lo8hnGvc78q8JE=";
        };

        doCheck = false; # faster builds
      });
    };
}
