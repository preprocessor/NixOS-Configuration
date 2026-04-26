{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.hand-of-evil = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
        name = "hand-of-evil";
        version = "1.2";

        src = fetchTarball {
          url = "https://github.com/Grief/hand-of-evil/releases/download/v1.2/hand-of-evil.tar.gz";
          sha256 = "0ld10fm8vgyig4kh0yv0bimwfwr8m9fw9cw424za6hlf48cgx6dm";
        };

        installPhase = ''
          mkdir -p $out/share/icons/${finalAttrs.name}
          cp -r $src/* $out/share/icons/${finalAttrs.name}
        '';
      });

    };

  w.default.nixpkgs.overlays = [ (_: f: { inherit (self.packages.${f.sys}) hand-of-evil; }) ];
}
