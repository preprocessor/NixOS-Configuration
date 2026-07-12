{ inputs, lib, ... }:
{
  tack.nix-index-database.url = "gh:nix-community/nix-index-database";

  w.default = {
    imports = [ inputs.nix-index-database.nixosModules.default ];
    programs = {
      command-not-found.enable = lib.mkForce false;
      nix-index-database.comma.enable = true;
    };
  };
}
