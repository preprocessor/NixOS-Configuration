#   o  .  ▄▀▀▀▄  .▄▀▄ * ▄▀▄ .  ..     o   .-.       +      .   .      |      .
#    +  ▄▀ ▄█▄ ▀▄▀ ▄ ▀▄▀ ▄ ▀▄   +  *       ) ) '   .    *          . -+-       *   .
# +.  ▄▀ ▄█████▄ ▄▛██▄ ▄▛██▄ ▀▄▄▄  ▄▄▄▄   '-´        ▄▄▄▄▄▄  ▄▄▀▀▀▀▄  |  ▄▀▀▀▄
#    █ ▄▛▘  ▀██▓ . ██▓   ██▓  ▄▄ ▀▀ ▄▄ ▀▄  ▄▀▀▀▀▀▀▄▄▀ ▄▄▄▄ ▀▀ ▄▄▓▓▄ ▀▄▄▀▀ ▃▓ ▀▄   o
#   █ ▄▛.*▝▙ ██▓   ██▓  .██▓ ▀▜█▓ .▀▜█▓ █▄▀ ▄████▄  ▄███████▄  ▀████▂▂▄▄▓███▓ ▀▄
#   █ ▀▙▁▁▟▘ ██▒   ██▒   ██▒ .▐█▓  .▐█▓ ▀ ▄██▀ /▀████▀▔█▓▔▔▀█▓  +▓██▀▀▀▀█████▒ ▀▄  .
#.   ▀▄ ▀▀ ▄ ██░+  ██░   ██░  ▐█▒.  ▐█▒  ▓██. ⭑ .   ╱' █▒  .█▒.  ███ █▀▄ ▀████▒ █
#      ▀▀▀▜▌▗███▖ ▗███▖ ▗███▖ ▟██▖  ▟██▖ ▒██▆▂     ╱  ▗██▖ ▗██▖ ▗███▖▐▌ █ ▀██░ ▄▀.  .
#     . * ▐▌▝███▘ ▝███▘ ▝███▘ ▜██▘  ▜██▘* ▀█████▆▄✶   ▝██▘ ▝██▘ ▝███▘▐▌  █ ▀░ ▄▀   .
# . o    ▄█▀ ██▒   ██▒ * ██▒ o▐█▓*  ▐█▓ . ╱  ╱.▀███▓ . █▓  +█▓   ▓█▓ █ .. ▀▄▄▄▀   ,
#      ▄▀ ▄▄███░.  ██░  .██▒. ▐█▓ .o▐█▒  ✦  ╱  ╱ ███▒  █▒' ▄█▒  ▓██▒ ▀▄        .:'
#    ▄▀ ▄▀▀▀████▄▄█████▄▄██░  ▝███▄▄███▙▂▁ ☆  ⭑ ▄██░ ▄▄██▄██▒ .▒███▒░ █ .  _.::'
#  o █ █ ▄▀▄ ▀▀▀▀▀ ▄▄ ▀▀▀▀▀ ▄▄▄ ▀▀▀▀████▀██▆▆▆██▀▀ ▄▄ ▀██▀▀ ▄▄█▀▀▀██░ █   (_:'  .
#    █ █ ▀▄ ▀▀▀▀▀▀▀  ▀▀▀▀▀▀█▀▀▀▀▀██ ▟█░ ▄▄ ▀▀▀ ▄▄▀▀  █ ██▄█▀▀ ▄▄▀▄ ▀ ▄▀
#    ▀▄ ▀ █   *  --+   .  █ ▄███▆▄▄▆█░ ▄▀ ▀▀▀▀▀   ╱  █ ██▀ ▄▀▀    ▀▀▀ .     +
# .    ▀▀▀  o  .     +    █ ▀ ▄ ▀▀▀▀▀ ▄▀  .   .  ╱   █ █ ▄▀  o    .      '     .*
#   +     .       .        ▀▀▀ ▀▀▀▀▀▀▀  o       *    ▀▄▄▄▀            .      o
#      .     *         .           *.              +       ..        o      .      +.
{
  description = "wyspr's Terrible NixOS Configuration";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports =
        with inputs.nixpkgs.lib;
        ./modules
        |> fileset.fileFilter (file: file.hasExt "nix" && !hasPrefix "_" file.name)
        |> fileset.toList;
    };

  inputs = {
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    base16.url = "github:SenchoPens/base16.nix";
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-file.url = "github:preprocessor/flake-file-dn";
    flake-parts.url = "github:hercules-ci/flake-parts";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "path:/home/wyspr/Configuration/Neovim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-stable.url = "https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz";
    qml-niri.url = "github:imiric/qml-niri/main";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
