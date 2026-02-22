{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    base16.url = "github:SenchoPens/base16.nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

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

    # System-wide theme engine
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # New York & San Francisco fonts
    apple-fonts = {
      url = "github:pperanich/nix-apple-fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix + Neovim
    nixstart-nvim = {
      url = "path:/home/wyspr/Configuration/Neovim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # inputs.import-tree.url = "github:vic/import-tree";
    # inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: {
    inherit inputs; # for repl

    nixosConfigurations.ramiel = inputs.nixpkgs.lib.nixosSystem {
      modules = [
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
