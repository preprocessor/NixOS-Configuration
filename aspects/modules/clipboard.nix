{ config, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.cliphist = pkgs.buildGoModule (finalAttrs: {
        pname = "cliphist";
        version = "0-unstable-2026-04-21";
        src = pkgs.fetchFromGitHub {
          owner = "sentriz";
          repo = "cliphist";
          rev = "980c85fab4a5bab04c6f14bed49b330fd18922ab";
          hash = "sha256-EeBIGhbWGw6BZ54kG9BhBc5OQGy3Ag/7eyXRImovqi8=";
        };
        vendorHash = "sha256-fDl+ul1t2Ux1w5WcCo6YMJtrcC20o+eUEO3NNycSNvI=";
        buildInputs = [ pkgs.bash ];
        postInstall = ''
          cp ${finalAttrs.src}/contrib/* $out/bin/
        '';
      });

      packages.cliphist-tui = pkgs.rustPlatform.buildRustPackage (final: {
        pname = "cliphist-tui";
        version = "0-unstable-2026-04-26";

        cargoLock.lockFile = final.src + "/Cargo.lock";
        src = pkgs.fetchFromGitHub {
          owner = "SHORiN-KiWATA";
          repo = "cliphist-tui";
          rev = "fd4a47baaba60598603d6c760512d2169479872b";
          hash = "sha256-wjgE9aladixbGfMXVdkvxEBJHKS2BEepbwILZro7d0A=";
        };
      });
    };

  w.default =
    { self', pkgs, ... }:
    {
      hj.packages = [
        self'.packages.cliphist
        self'.packages.cliphist-tui
      ];

      wrappers.niri.settings.spawn-at-startup = [
        [
          "wl-paste"
          "--type"
          "text"
          "--watch"
          "cliphist"
          "store"
        ]
        [
          "wl-paste"
          "--type"
          "image"
          "--watch"
          "cliphist"
          "store"
        ]
        [
          "wl-clip-persist"
          "--clipboard"
          "regular"
        ]
      ];

      environment.variables = {
        CLIPHIST_MAX_STORE_SIZE = "1GB";
      };

      wrappers.otter-launcher.modules =
        let
          resize = config.utils.otterResize;
        in
        [
          {
            description = "clipboard manager";
            prefix = "cc";
            cmd = resize 800 1000 "cliphist-tui";
          }
        ];
    };
}
