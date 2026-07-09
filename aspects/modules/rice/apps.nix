{
  perSystem =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    {
      packages = {
        pond = pkgs.stdenv.mkDerivation {
          name = "pond";
          pname = "pond";

          src = pkgs.fetchFromGitLab {
            owner = "alice-lefebvre";
            repo = "pond";
            rev = "1b74089f0d44f13efe8f695849d7cb8c7c6643de";
            hash = "sha256-xG2dQ0hzQMNGV2NreLzXQWeDE5QJc0j6A5JBXmSMavk=";
          };

          nativeBuildInputs = [ pkgs.ncurses ];

          patchPhase = ''
            substituteInPlace Makefile \
              --replace-fail 'curses' 'ncurses' \
              --replace-fail 'bin/pond' 'pond' \
              --replace-fail 'rm -f /usr/local/games/pond' ''' \
              --replace-fail '/usr/games' 'bin'
          '';

          installPhase = "install -m755 -Dt $out/bin pond";
        };

        voxcii = pkgs.stdenv.mkDerivation {
          name = "voxcii";
          pname = "voxcii";

          src = pkgs.fetchFromGitHub {
            owner = "ashish0kumar";
            repo = "voxcii";
            rev = "c7ff4ee02db3498fdf3da085a270fabc60fdd49c";
            hash = "sha256-6lMdPBqvegwaBCQ6QZ+iFVSx4kTV9tgXBN0KVL2x3f4=";
          };

          nativeBuildInputs = [ pkgs.ncurses ];
          installPhase = "install -m755 -Dt $out/bin voxcii";
        };

        gotermfx = pkgs.buildGoModule (finalAttrs: {
          pname = "gotermfx";
          version = "0.1.0";
          __structuredAttrs = true;

          src = pkgs.fetchFromGitHub {
            owner = "mohamedation";
            repo = "gotermfx";
            tag = "v${finalAttrs.version}";
            hash = "sha256-bqJucLcGFrS2kHhPF7J7TqcgXHCywjwuW2n+ghujoLM=";
          };

          vendorHash = null;
          ldflags = [ "-s" ];

          meta = {
            description = "Modular terminal animations in Go, zero dependencies";
            homepage = "https://github.com/mohamedation/gotermfx";
            license = lib.licenses.mit;
            maintainers = with lib.maintainers; [ wyspr ];
            mainProgram = "gotermfx";
          };
        });

      };

      devShells.wyce = pkgs.mkShell {
        packages =
          with pkgs;
          [
            asciiquarium-transparent
            astroterm
            cbonsai
            pipes-rs
            drift
            neo
          ]
          ++ (with self'.packages; [
            voxcii
            pond
          ]);
      };
    };

}
