{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/master"; # master branch
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

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # inputs.import-tree.url = "github:vic/import-tree";
    # inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: {
    inherit inputs; # for repl

    nixosConfigurations.ramiel = inputs.nixpkgs.lib.nixosSystem {
      modules = [
	inputs.stylix.nixosModules.stylix
	inputs.nixcord.homeModules.nixcord
        ./common
        ./ramiel # system specific
      ];
      specialArgs = {
        inherit inputs;
      };
    };
  };
}
