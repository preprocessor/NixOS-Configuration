{
  w.default =
    { pkgs, lib, ... }:
    {
      programs.nano.enable = lib.mkForce false; # Take out the trash

      hj.packages = with pkgs; [
        imagemagick
        trash-cli
        ripgrep
        (gnuplot.override { withQt = true; })
        mdfried
        chafa
        wget
        tree
        just # a command runnner
        isd # inspect system d
        mcat
        gum
        fd
        sd
        jq # parse json
      ];
    };
}
