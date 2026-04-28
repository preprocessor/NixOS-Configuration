{
  envoy.miku.github = "supermariofps/hatsune-miku-windows-linux-cursors";

  w.default =
    { envoy, ... }:
    {
      nixpkgs.overlays = [
        (_: f: {
          hatsune-miku-cursor = f.stdenvNoCC.mkDerivation {
            inherit (envoy.miku) src version pname;

            installPhase = ''
              mkdir -p $out/share/icons
              cp -r $src/miku-cursor-linux $out/share/icons/
            '';
          };

        })
      ];
    };
}
