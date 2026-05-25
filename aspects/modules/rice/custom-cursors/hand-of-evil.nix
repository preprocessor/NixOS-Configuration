{
  envoy.hand-of-evil.tarball = "https://github.com/Grief/hand-of-evil/releases/download/v1.2/hand-of-evil.tar.gz";

  w.default =
    { envoy, ... }:
    {
      nixpkgs.overlays = [
        (_: f: {
          hand-of-evil = f.stdenvNoCC.mkDerivation (finalAttrs: {
            inherit (envoy.hand-of-evil) name version src;

            installPhase = ''
              mkdir -p $out/share/icons/${finalAttrs.name}
              cp -r $src/* $out/share/icons/${finalAttrs.name}
            '';
          });

        })
      ];
    };
}
