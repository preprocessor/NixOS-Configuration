{ inputs, ... }:
{
  tack.inputs = {
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
          buildInputs = [ pkgs.ncurses ];
          buildPhase = "gcc -std=gnu99 -Wall -Os $src/pond.c -lncurses -o pond";
          installPhase = "install -m555 -Dt $out/bin pond";
        };
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
        ++ [ self'.packages.pond ]
        ++ (with packages'; [
          pixprint
          rsakura
        ]);
    };

}
