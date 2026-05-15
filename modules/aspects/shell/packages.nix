{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        nix-output-monitor
        imagemagick
        trash-cli
        ripgrep
        nix-init
        mdfried
        gowall
        chafa
        nurl
        just # a command runner
        wget
        tree
        isd # inspect system d
        mcat
        gum
        fd
        sd
        jq # parse json
        # custom packages
        eye
        gbc
        ocr
        # wyspr_waow
      ];
    };
}
