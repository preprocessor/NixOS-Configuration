{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        imagemagick
        fetchutils
        trash-cli
        ripgrep
        nix-init
        nvim-pkg # neovim
        silicon
        npins
        nurl
        just # a command runner
        wget
        tree
        isd # inspect system d
        btop
        mcat
        gum
        fd
        jq # parse json
        # custom packages
        # eye
        # gbc
        # ocr
        # wyspr_waow
      ];
    };
}
