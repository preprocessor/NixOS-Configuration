{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        imagemagick
        trash-cli
        fetchutils
        nvim-pkg # neovim
        just # a command runner
        wget
        tree
        isd # inspect system d
        btop
        jq # parse json
        bemoji_tofi
        wyspr_eye
        wyspr_gbc
        # wyspr_waow
        zide
      ];
    };
}
