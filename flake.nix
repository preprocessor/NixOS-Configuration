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
    inputs: ./modules |> inputs.import-tree |> inputs.flake-parts.lib.mkFlake { inherit inputs; };

  inputs = {
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    base16.url = "github:SenchoPens/base16.nix";
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat.url = "github:edolstra/flake-compat";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils.inputs.systems.follows = "systems";
    gen-luarc = {
      url = "github:mrcjkb/nix-gen-luarc-json";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };
    gimp.url = "path:/home/wyspr/Configuration/GIMP";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
    };
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
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
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
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
    otterlauncher = {
      url = "github:kuokuo123/otter-launcher";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    qml-niri = {
      url = "github:imiric/qml-niri/main";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    rabid = {
      url = "path:/home/wyspr/Configuration/Rabid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        base16.follows = "base16";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    system76-scheduler-niri = {
      url = "github:Kirottu/system76-scheduler-niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/x86_64-linux";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        vicinae.follows = "vicinae";
      };
    };
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    yazi-plugin-fuzzy-search.url = "github:onelocked/fuzzy-search.yazi";
  };
}
