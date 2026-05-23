{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        imagemagick
        trash-cli
        ripgrep
        mdfried
        chafa
        wget
        tree
        isd # inspect system d
        mcat
        gum
        fd
        sd
        jq # parse json
      ];
    };
}
