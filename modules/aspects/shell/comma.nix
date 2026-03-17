{ inputs, ... }:
{
  flake.modules.homeManager.default = {

    imports = [
      inputs.nix-index-database.homeModules.default
    ];

    programs.nix-index-database.comma.enable = true;
  };
}
