let
  name = "moon";
in
{
  w.default =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [
        (_: f: {
          ${name} = f.stdenvNoCC.mkDerivation (finalAttrs: {
            inherit name;
            version = "1.0";
            src = ./bin;
            installPhase = "install $src/${name} -Dm0755 $out/bin/${name}";
          });
        })
      ];

      hj.packages = [ pkgs.${name} ];
    };
}
