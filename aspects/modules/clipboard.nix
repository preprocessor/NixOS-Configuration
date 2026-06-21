{ config, ... }:
{
  perSystem =
    { pkgs, birdee, ... }:
    {
      packages.cliphist = birdee.lib.wrapPackage {
        inherit pkgs;
        env.CLIPHIST_MAX_STORE_SIZE = "1GB";
        package = pkgs.buildGoModule (final: {
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
            cp ${final.src}/contrib/* $out/bin/
          '';
          patches = [
            (pkgs.writeText "fix-browser-copy-with-meta.patch" # go
              ''
                diff --git a/cliphist.go b/cliphist.go
                index 8e1eb95..375f807 100644
                --- a/cliphist.go
                +++ b/cliphist.go
                @@ -127,7 +127,7 @@ func store(dbPath string, in io.Reader, maxDedupeSearch, maxItems uint64, minLen
                 	}
                 	defer db.Close()

                -	if len(bytes.TrimSpace(input)) == 0 {
                +	if len(bytes.TrimSpace(input)) == 0 || isBrowserImageFallback(input) {
                 		return nil
                 	}
                 	tx, err := db.Begin(true)
                @@ -564,3 +564,13 @@ func parseSize(s string) (uint64, error) {
                 	}
                 	return num, nil
                 }
                +
                +func isBrowserImageFallback(input []byte) bool {
                +	s := string(input)
                +	const meta = "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\">"
                +	if !strings.HasPrefix(s, meta) {
                +		return false
                +	}
                +	rest := strings.TrimSpace(s[len(meta):])
                +	return strings.HasPrefix(rest, "<img") && strings.HasSuffix(rest, ">")
                +}
                --
                2.53.0
              ''
            )
          ];
        });
      };

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
      hj.packages = [ pkgs.wl-clipboard ];

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
      };

      wrappers.hyprland.startup = [
        "${pkgs.wl-clip-persist}/bin/wl-clip-persis --clipboard regular"
      ];

      _file = ./clipboard.nix;
    };
}
