{
  tack.inputs = {
    rsakura.url = "gh:preprocessor/rsakura";
    pixprint.url = "gh:preprocessor/pixprint";
    pond = {
      url = "gitlab:alice-lefebvre/pond";
      type = "fetch";
    };
  };

  perSystem =
    { inputs, pkgs, ... }:
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
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        (gnuplot.override { withQt = true; })
        imagemagick
        mcat
      ];
    };

  exo.core =
    {
      packages',
      self',
      pkgs,
      lib,
      ...
    }:
    {
      programs.nano.enable = lib.mkForce false; # Take out the trash

      hj.packages =
        with pkgs;
        [
          uutils-coreutils-noprefix
          diffoscopeMinimal
          trash-cli
          ripgrep
          chafa
          wget
          tree
          just # a command runnner
          fd # faster find
          sd # sed alternative
          jq # parse json
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
