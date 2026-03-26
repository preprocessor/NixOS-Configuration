# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    allfollow.url = "github:spikespaz/allfollow";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    base16.url = "github:SenchoPens/base16.nix";
    direnv-instant.url = "github:Mic92/direnv-instant";
    fish-plugin-enhancd = {
      url = "github:babarot/enhancd";
      flake = false;
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    ghostty-shaders = {
      url = "github:sahaj-b/ghostty-cursor-shaders";
      flake = false;
    };
    gimp.url = "path:/home/wyspr/Configuration/GIMP";
    home-manager.url = "github:nix-community/home-manager/master";
    import-tree.url = "github:vic/import-tree";
    neovim.url = "path:/home/wyspr/Configuration/Neovim/";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-yazi-plugins.url = "github:lordkekz/nix-yazi-plugins";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    rabid.url = "path:/home/wyspr/Configuration/Rabid";
    stylix.url = "github:nix-community/stylix";
    worktrunk.url = "github:max-sixty/worktrunk/v0.30.1";
    yazi-plugin-faster-piper = {
      url = "github:alberti42/faster-piper.yazi";
      flake = false;
    };
    yazi-plugin-fuzzy-search.url = "github:onelocked/fuzzy-search.yazi";
    yazi-theme-everforest = {
      url = "github:Chromium-3-Oxide/everforest-medium.yazi";
      flake = false;
    };
  };
}
