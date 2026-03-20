{ inputs, ... }:
{
  flake-file.inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake-file.inputs.direnv-instant = {
    url = "github:Mic92/direnv-instant";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.default.imports = [
    inputs.nix-index-database.homeModules.default
    inputs.direnv-instant.homeModules.direnv-instant
  ];

  flake.modules.homeManager.default.programs = {
    nix-index-database.comma.enable = true;
    nix-init.enable = true;

    direnv = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    direnv-instant = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "$HOME/Configuration/NixOS"; # sets NH_OS_FLAKE variable for you
    };

    nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
