{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    base16.url = "github:SenchoPens/base16.nix";

    # inputs.import-tree.url = "github:vic/import-tree";
    # inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: {
    inherit inputs; # for repl

    nixosConfigurations.ramiel = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.base16.nixosModule
        inputs.stylix.nixosModules.stylix
        ./common
        ./ramiel # system specific
        ./modules
      ];
      specialArgs = {
        inherit inputs;
      };
    };
  };
}
