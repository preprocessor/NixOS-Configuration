{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.hatsune-miku-cursor = pkgs.stdenvNoCC.mkDerivation {
        pname = "hatsune-miku-cursor";
        version = "1.2.6";

        src = pkgs.fetchFromGitHub {
          owner = "supermariofps";
          repo = "hatsune-miku-windows-linux-cursors";
          rev = "471ff88156e9a3dc8542d23e8cae4e1c9de6e732";
          hash = "sha256-HCHo4GwWLvjjnKWNiHb156Z+NQqliqLX1T1qNxMEMfE=";
        };

        installPhase = ''
          mkdir -p $out/share/icons
          cp -r $src/miku-cursor-linux $out/share/icons/
        '';
      };
    };

  w.default.nixpkgs.overlays = [ (_: f: { inherit (self.packages.${f.sys}) hatsune-miku-cursor; }) ];
}
