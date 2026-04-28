{ self, ... }:
{
  envoy.miku.github = "supermariofps/hatsune-miku-windows-linux-cursors";

  perSystem =
    { pkgs, envoy, ... }:
    {
      packages.hatsune-miku-cursor = pkgs.stdenvNoCC.mkDerivation {
        inherit (envoy.miku) src version pname;

        installPhase = ''
          mkdir -p $out/share/icons
          cp -r $src/miku-cursor-linux $out/share/icons/
        '';
      };
    };

  w.default.nixpkgs.overlays = [ (_: f: { inherit (self.packages.${f.sys}) hatsune-miku-cursor; }) ];
}
