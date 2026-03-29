{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
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
        bemoji_tofi
        wyspr_eye
        wyspr_gbc
        ocr
        # wyspr_waow
      ];
    };
}
