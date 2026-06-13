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

        cargoHash = "sha256-KHlEw5RZNeCYeNngPvgDFvBFMKD2OZrx8sg2QWdwjQ8=";
        src = pkgs.fetchFromGitHub {
          owner = "SHORiN-KiWATA";
          repo = "cliphist-tui";
          rev = "fd4a47baaba60598603d6c760512d2169479872b";
          hash = "sha256-wjgE9aladixbGfMXVdkvxEBJHKS2BEepbwILZro7d0A=";
        };
      });

      _file = ./clipboard.nix;
    };

  w.default =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    {
      systemd.user.services = {
        cliphist-text = {
          description = "Clipboard history service (Text)";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${self'.packages.cliphist}/bin/cliphist store";
            Restart = "on-failure";
          };
        };

        cliphist-image = {
          description = "Clipboard history service (Images)";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${self'.packages.cliphist}/bin/cliphist store";
            Restart = "on-failure";
          };
        };

        clip-persist = {
          description = "Persistent clipboard";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persis --clipboard regular";
            Restart = "on-failure";
          };
        };
      };

      environment.variables = {
        CLIPHIST_MAX_STORE_SIZE = "1GB";
      };

      wrappers.otter-launcher.modules =
        let
          resize = config.utils.otterResize;
        in
        [
          {
            description = "clipboard";
            prefix = "cb";
            cmd = resize 800 1000 (lib.getExe' self'.packages.cliphist-tui "cliphist-tui");
          }
        ];

      _file = ./clipboard.nix;
    };
}
