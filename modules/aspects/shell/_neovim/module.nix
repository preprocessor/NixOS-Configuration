{ inputs, ... }:
{

  ff.gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

  w.default = {
    nixpkgs.overlays = [ inputs.gen-luarc.overlays.default ];

  };
}
