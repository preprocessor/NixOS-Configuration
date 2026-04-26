{ self, ... }:
let
  name = "gbc";
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.${name} = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
        inherit name;
        version = "1.0";
        src = ./bin;
        installPhase = "install $src/${name} -Dm0755 $out/bin/${name}";
      });
    };

  w.default.nixpkgs.overlays = [ (_: f: { ${name} = self.packages.${f.sys}.${name}; }) ];
}
