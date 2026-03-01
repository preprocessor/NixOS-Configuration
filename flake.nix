{
  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.ramiel = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./common
          ./modules
          ./ramiel # system specific
        ];
        specialArgs = { inherit inputs; };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    # NixOS modules covering hardware quirks
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # Apple's New York & San Francisco fonts
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    # Manage user environments
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manage discord with Nix
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Chromium-based privacy-focused browser
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Cache nix database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Colorscheme
    base16.url = "github:SenchoPens/base16.nix";
    # System-wide theme engine
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Non-blocking direnv integration daemon
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix + Neovim
    neovim.url = "path:/home/wyspr/Configuration/Neovim/";
    # Hevel window manager
    # hevel.url = "path:/home/wyspr/Configuration/Hevel/";
    # River window manager
    river.url = "path:/home/wyspr/Configuration/River/";

    # inputs.import-tree.url = "github:vic/import-tree";
    # inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  };
}
