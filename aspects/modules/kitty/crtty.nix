{ inputs, ... }:
{
  inputs.crtty = {
    url = "github:kosa12/CRTty";
    flake = false;
  };

  perSystem =
    { pkgs, ... }:
    {
      packages.crtty = pkgs.rustPlatform.buildRustPackage {
        pname = "crtty";
        version = "0.1.3";
        src = inputs.crtty;
        cargoLock.lockFile = "${inputs.crtty}/Cargo.lock";
        doCheck = false;

        buildPhase = "cargo build --release --workspace";

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin $out/lib
          cp target/release/crtty   $out/bin/
          cp target/release/libcrtty_crt.so $out/lib/
          cp crtty.conf.example $out/share/doc/crtty/crtty.conf.example 2>/dev/null || true
          runHook postInstall
        '';

        meta = with pkgs.lib; {
          description = "Post-processing shader framework for kitty terminal via LD_PRELOAD";
          homepage = "https://github.com/kosa12/CRTty";
          license = licenses.mit;
          platforms = platforms.linux;
          mainProgram = "crtty";
        };
      };
    };

  w.desktop =
    { self', ... }:
    {
      hj.packages = [ self'.packages.crtty ];

      hj.xdg.config.files."crtty/kitty.conf".text = ''
        enabled=1
        scanline_intensity=0.25
        phosphor_strength=2.0
        curvature=0.03
        vignette=0.10
        aberration=0.007
      '';
    };
}
