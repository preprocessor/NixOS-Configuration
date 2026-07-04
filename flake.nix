#   o  .  ▄▀▀▀▄  .▄▀▄ * ▄▀▄ .  ..     o   .-.       +      .   .      |      .
#    +  ▄▀ ▄█▄ ▀▄▀ ▄ ▀▄▀ ▄ ▀▄   +  *       ) ) '   .    *          . -+-       *   .
# +.  ▄▀ ▄█████▄ ▄▛██▄ ▄▛██▄ ▀▄▄▄  ▄▄▄▄   '-´        ▄▄▄▄▄▄  ▄▄▀▀▀▀▄  |  ▄▀▀▀▄
#    █ ▄▛▘  ▀██▓ . ██▓   ██▓  ▄▄ ▀▀ ▄▄ ▀▄  ▄▀▀▀▀▀▀▄▄▀ ▄▄▄▄ ▀▀ ▄▄▓▓▄ ▀▄▄▀▀ ▃▓ ▀▄   o
#   █ ▄▛.*▝▙ ██▓   ██▓  .██▓ ▀▜█▓ .▀▜█▓ █▄▀ ▄████▄  ▄███████▄╱ ▀████▂▂▄▄▓███▓ ▀▄
#   █ ▀▙▁▁▟▘ ██▒   ██▒   ██▒ .▐█▓  .▐█▓ ▀ ▄██▀  ▀████▀▔█▓▔▔▀█▓ ╱+▓██▀▀▀▀█████▒ ▀▄  .
#. ╱ ▀▄ ▀▀ ▄ ██░+  ██░   ██░  ▐█▒.  ▐█▒  ▓██. ⭑ ╱.  ╱' █▒  .█▒╱. ███ █▀▄ ▀████▒ █
# ╱  ╱ ▀▀▀▜▌▗███▖ ▗███▖ ▗███▖ ▟██▖  ▟██▖ ▒██▆▂     ╱  ▗██▖ ▗██▖ ▗███▖▐▌ █ ▀██░ ▄▀.  .
#   ╱ . * ▐▌▝███▘ ▝███▘ ▝███▘ ▜██▘  ▜██▘* ▀█████▆▄✶   ▝██▘ ▝██▘ ▝███▘▐▌  █ ▀░ ▄▀   .
# . o    ▄█▀ ██▒   ██▒ * ██▒ o▐█▓*  ▐█▓ . ╱   .▀███▓ . █▓  +█▓   ▓█▓ █ .. ▀▄▄▄▀   ,
#      ▄▀ ▄▄███░.  ██░  .██▒. ▐█▓ .o▐█▒  ✦  *  ╱ ███▒  █▒' ▄█▒  ▓██▒ ▀▄   ╱  ╱ .:'
#    ▄▀ ▄▀▀▀████▄▄█████▄▄██░  ▝███▄▄███▙▂▁ ☆  ⭑ ▄██░ ▄▄██▄██▒ .▒███▒░ █ .╱ _.::'
#  o █ █ ▄▀▄ ▀▀▀▀▀ ▄▄ ▀▀▀▀▀ ▄▄▄ ▀▀▀▀████▀██▆▆▆██▀▀ ▄▄ ▀██▀▀ ▄▄█▀▀▀██░ █   (_:'  .
#    █ █ ▀▄ ▀▀▀▀▀▀▀ ╱▀▀▀▀▀▀█▀▀▀▀▀██ ▟█░ ▄▄ ▀▀▀ ▄▄▀▀╱ █ ██▄█▀▀ ▄▄▀▄ ▀ ▄▀
#    ▀▄ ▀ █   *    ╱   .  █ ▄███▆▄▄▆█░ ▄▀ ▀▀▀▀▀   ╱  █ ██▀ ▄▀▀   ╱▀▀▀ .     +
# .  ╱ ▀▀▀  o  .     +--  █ ▀ ▄ ▀▀▀▀▀ ▄▀  .   .  ╱  ╱█ █ ▄▀  o  ╱ .      '     .*
#   ╱     .       .      ╱ ▀▀▀ ▀▀▀▀▀▀▀  o       *  ╱ ▀▄▄▄▀            .      o
#      .     *         .           *.              +       ..        o      .      +.
#
# This file is generated with flake-file. Any edits will be overwritten.
{
  description = "wyspr's Terrible NixOS Configuration";

  outputs =
    inputs:
    let
      evaluation = inputs.flake-parts.lib.evalFlakeModule { inherit inputs; } {
        # Import all *.nix files in the ./aspects directory
        # Except ones that start with '_'
        imports =
          with inputs.nixpkgs.lib;
          ./aspects
          |> fileset.fileFilter (file: file.hasExt "nix" && !hasPrefix "_" file.name)
          |> fileset.toList;

        _module.args.rootPath = ./.;
      };
    in
    { inherit evaluation; } // evaluation.config.processedFlake;

  inputs = {
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    base16.url = "github:senchopens/base16.nix";
    birdee = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crtty = {
      url = "github:kosa12/CRTty";
      flake = false;
    };
    flake-file.url = "github:denful/flake-file";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "path:/home/wyspr/Configuration/Neovim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-gaming-edge = {
      url = "path:/home/wyspr/Configuration/nix-gaming-edge";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-core.url = "github:manic-systems/nixos-core/refs/tags/v1.0.1";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    pixprint.url = "github:preprocessor/pixprint";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tray-tui.url = "github:Levizor/tray-tui";
    yazi-fuzzy-search = {
      url = "github:onelocked/fuzzy-search.yazi";
      flake = false;
    };
    yazi-no-header = {
      url = "github:onelocked/no-header-prompt.yazi";
      flake = false;
    };
    yazi-plugins = {
      url = "github:AminurAlam/yazi-plugins";
      flake = false;
    };
  };
}
