{
  tack.inputs = {
    rsakura = {
      url = "gh:preprocessor/rsakura";
      group = "tui";
    };
    pixprint = {
      url = "gh:preprocessor/pixprint";
      group = "tui";
    };
  };

  exo.mods.desktop =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        (gnuplot.override { withQt = true; })
        libreoffice-qt
        imagemagick
        mcat
      ];
    };

  exo.core =
    {
      packages',
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
          just # a command runner
          fd # faster find
          sd # sed alternative
          jq # parse json
          cbonsai
          pipes-rs
          drift
          pond
          neo
        ]
        ++ (with packages'; [
          pixprint
          rsakura
        ]);
    };
}
