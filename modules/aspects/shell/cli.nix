{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        imagemagick
        trash-cli
        fastfetch
        ripgrep
        nvim-pkg # neovim
        just # a command runner
        wget
        tree
        isd # inspect system d
        btop
        eza # better ls
        fd # better find
        jq # parse json
        uutils-coreutils-noprefix
        bemoji_tofi
        wyspr_eye
        wyspr_gbc
        # wyspr_waow
        zide
      ];
    };
}
