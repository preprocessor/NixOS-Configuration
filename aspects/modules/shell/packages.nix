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
        chafa
        wget
        tree
        just # a command runnner
        isd # inspect system d
        mcat
        fd
        sd
        jq # parse json
      ];
    };
}
