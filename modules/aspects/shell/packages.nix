{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        imagemagick
        trash-cli
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
        wyspr-eye
        wyspr-gbc
        ocr
        # wyspr_waow
      ];
    };
}
