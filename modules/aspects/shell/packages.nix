{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        imagemagick
        fetchutils
        xrandr
        trash-cli
        ripgrep
        nix-init
        nvim-pkg # neovim
        silicon
        chafa
        nurl
        just # a command runner
        wget
        tree
        isd # inspect system d
        btop-rocm
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
