{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        imagemagick
        ripgrep
        fd
        trash-cli
        nix-init
        nurl
        fetchutils
        nvim-pkg # neovim
        silicon
        just # a command runner
        wget
        tree
        isd # inspect system d
        btop
        mcat
        gum
        jq # parse json
        # custom packages
        eye
        gbc
        ocr
        # wyspr_waow
      ];
    };
}
