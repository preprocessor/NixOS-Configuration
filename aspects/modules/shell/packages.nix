{
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
    { pkgs, lib, ... }:
    {
      programs.nano.enable = lib.mkForce false; # Take out the trash

      hj.packages = with pkgs; [
        trash-cli
        ripgrep
        chafa
        wget
        tree
        just # a command runnner
        isd # inspect system d
        fd
        sd
        jq # parse json
      ];
    };
}
