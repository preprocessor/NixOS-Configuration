{ inputs, ... }:
{
  flake-file.inputs = {
    direnv-instant.url = "github:Mic92/direnv-instant";
    nix-index-database.url = "github:nix-community/nix-index-database";
  };

  flake.modules.nixos.default = {
    nix.settings = {
      extra-substituters = [ "https://bazinga.cachix.org" ];
      extra-trusted-public-keys = [ "bazinga.cachix.org-1:WI9TV6l0gBVhcfY7OQM5zWqYmESIarKME0fjVN6yDYU=" ];
    };

    hj.xdg.config.files."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
  };

  flake.modules.homeManager.default = {
    imports = [
      inputs.direnv-instant.homeModules.direnv-instant
      inputs.nix-index-database.homeModules.default
    ];

    programs = {
      nix-index-database.comma.enable = true;
      nix-init.enable = true;

      direnv = {
        enable = true;
        silent = true;
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
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 5";
          dates = "daily";
        };
        flake = "$HOME/Configuration/NixOS"; # sets NH_OS_FLAKE variable for you
      };

      nix-your-shell = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
