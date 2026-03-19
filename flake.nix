{
  outputs =
    { ... }@inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    import-tree.url = "github:vic/import-tree"; # Import all nix files in a directory tree.
    flake-parts.url = "github:hercules-ci/flake-parts"; # Simplify Nix Flakes with the module system
    nixos-hardware.url = "github:NixOS/nixos-hardware"; # NixOS modules covering hardware quirks
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix"; # Apple's New York & San Francisco fonts
    driftwm = "github:malbiruk/driftwm";
    # wrappers.url = "github:lassulus/wrappers";

    # Manage user environments
    home-manager = {
      url = "github:nix-community/home-manager/master";
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

    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "path:/home/wyspr/Configuration/Neovim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rabid = {
      url = "path:/home/wyspr/Configuration/Rabid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gimp.url = "path:/home/wyspr/Configuration/GIMP";

  };
}
