{
  perSystem =
    { pkgs, ... }:
    {
      packages.toilet = pkgs.symlinkJoin {
        name = "toilet";
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/toilet \
            --add-flags "--directory $out/share/figlet" \
            --add-flags "--termwidth"
        '';
        paths = [
          pkgs.toilet
          (pkgs.stdenvNoCC.mkDerivation {
            name = "figlet-fonts";
            src = pkgs.fetchzip {
              url = "https://github.com/xero/figlet-fonts/archive/refs/heads/main.zip";
              hash = "sha256-QogGNQ772bcYLOzgO0i6ydbzxjn5jnXNav72vW/SXm8=";
            };
            allowSubstitutes = false;
            preferLocalBuild = true;
            dontUnpack = true;
            dontBuild = true;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/figlet
              cp -r $src/* $out/share/figlet/
            '';
          })
        ];
      };
    };

  exo.core =
    { self', ... }:
    {
      hj.packages = [ self'.packages.toilet ];
    };
}
