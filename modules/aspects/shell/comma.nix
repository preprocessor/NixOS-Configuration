{ inputs, lib, ... }:
{
  ff.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  w.default = {
    imports = [ inputs.nix-index-database.nixosModules.default ];
    programs = {
      command-not-found.enable = lib.mkForce false;
      nix-index-database.comma.enable = true;
    };
  };
}
