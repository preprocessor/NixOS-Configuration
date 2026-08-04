{ inputs, ... }:
{
  tack = {
    rsakura.url = "gh:preprocessor/rsakura";
    pixprint.url = "gh:preprocessor/pixprint";
    pond = {
      url = "gitlab:alice-lefebvre/pond";
      type = "fetch";
    };
    voxcii = {
      url = "gh:ashish0kumar/voxcii";
      type = "fetch";
    };
    terminal-toys = {
      url = "gh:seebass22/terminal-toys";
      type = "fetch";
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        pond = pkgs.stdenv.mkDerivation {
          name = "pond";
          pname = "pond";
          src = inputs.pond;
          allowSubstitutes = false;
          preferLocalBuild = true;
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
          src = inputs.voxcii;
          allowSubstitutes = false;
          preferLocalBuild = true;
          nativeBuildInputs = [ pkgs.ncurses ];
          installPhase = "install -m755 -Dt $out/bin voxcii";
        };

        terminal-toys = pkgs.rustPlatform.buildRustPackage (final: {
          name = "terminal-toys";
          pname = "terminal-toys";
          src = inputs.terminal-toys;
          cargoLock.lockFile = final.src + "/Cargo.lock";
        });
      };
    };

  exo.mods.desktop =
    {
      pkgs,
      self',
      packages',
      ...
    }:
    {
      hj.packages =
        with pkgs;
        [
          cbonsai
          pipes-rs
          drift
          neo
        ]
        ++ (with self'.packages; [
          voxcii
          pond
          terminal-toys
        ])
        ++ (with packages'; [
          pixprint
          rsakura
        ]);
    };

}
