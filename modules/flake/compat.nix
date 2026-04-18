{
  flake-file.inputs = {
    systems.url = "github:nix-systems/x86_64-linux";
    flake-compat.url = "github:edolstra/flake-compat";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    flake-utils.inputs.systems.follows = "systems";
    gen-luarc = {
      url = "github:mrcjkb/nix-gen-luarc-json";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };
}
