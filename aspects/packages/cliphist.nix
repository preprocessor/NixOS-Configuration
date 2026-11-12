{
  tack.inputs = {
    cliphist-src = {
      url = "gh:sentriz/cliphist";
      type = "fetch";
      group = "cliphist";
    };
    cliphist-tui-src = {
      url = "gh:SHORiN-KiWATA/cliphist-tui";
      type = "fetch";
      group = "cliphist";
    };
  };

  perSystem =
    {
      wrapPackage,
      inputs,
      pkgs,
      ...
    }:
    {
      remotePackages.cliphist-tui = wrapPackage {
        package = pkgs.rustPlatform.buildRustPackage (final: {
          pname = "cliphist-tui";
          version = "0-unstable-2026-04-26";
          cargoLock.lockFile = final.src + "/Cargo.lock";
          src = inputs.cliphist-tui-src;
        });

        runtimePackages = [
          pkgs.ffmpegthumbnailer
          pkgs.chafa
        ];
      };

      remotePackages.cliphist = wrapPackage {
        package = pkgs.buildGoModule (final: {
          pname = "cliphist";
          version = "0-unstable-2026-04-21";
          src = inputs.cliphist-src;
          vendorHash = "sha256-fDl+ul1t2Ux1w5WcCo6YMJtrcC20o+eUEO3NNycSNvI=";
          buildInputs = [ pkgs.bash ];
          postInstall = "cp ${final.src}/contrib/* $out/bin/ ";
          patches = [
            (pkgs.fetchpatch2 {
              name = "add_browser_meta";
              url = "https://gist.githubusercontent.com/preprocessor/992a0f043422fdcf8d2b75f512efc49c/raw/609a5006b38c19eab3a9ef01a0b389a73d0ec7c7/cliphist-fix-browser-copy-with-meta.patch";
              hash = "sha256-qztlP1GltaQutNTFApvk2R2Ezsa5irPrTLU2vshJ0hw=";
            })
          ];
        });

        env.CLIPHIST_MAX_STORE_SIZE = "1GB";
      };
    };
}
