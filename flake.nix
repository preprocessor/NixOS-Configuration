{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; #

    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of Nixvim.
      # url = "github:nix-community/nixvim/nixos-25.11";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master"; # master branch
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    inherit inputs; # for repl !

    nixosConfigurations.ramiel = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        ./common
	./ramiel # >:3
      ];
      specialArgs = {
        inherit inputs;
      };
    };

    packages.x86_64-linux = let 
      nixvim = inputs.nixvim.legacyPackages.x86_64-linux;
      nvim = nixvim.makeNixvim (import ./nixvim);
    in 
    {
      inherit nvim;
    };
  };
}
