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
  description = "wyspr's NixOS Configuration";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    base16.url = "github:SenchoPens/base16.nix";
    bat-syntax-justfile = {
      url = "github:nk9/just_sublime";
      flake = false;
    };
    colorschemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    direnv-instant.url = "github:Mic92/direnv-instant";
    everforest-theme-collection = {
      url = "github:neuromaancer/everforest_collection";
      flake = false;
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils.inputs.systems.follows = "systems";
    ghostty.url = "github:ghostty-org/ghostty";
    ghostty-cursor-shaders = {
      url = "github:sahaj-b/ghostty-cursor-shaders";
      flake = false;
    };
    gimp.url = "path:/home/wyspr/Configuration/GIMP";
    hjem.url = "github:feel-co/hjem";
    home-manager.url = "github:nix-community/home-manager/master";
    import-tree.url = "github:vic/import-tree";
    neovim = {
      url = "path:/home/wyspr/Configuration/Neovim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:niri-wm/niri";
    niri-shaders-collection = {
      url = "github:jgarza9788/niri-animation-collection";
      flake = false;
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-stable.url = "https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz";
    qml-niri.url = "github:imiric/qml-niri/main";
    rabid = {
      url = "path:/home/wyspr/Configuration/Rabid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.base16.follows = "base16";
    };
    system76-scheduler-niri.url = "github:Kirottu/system76-scheduler-niri";
    systems.url = "github:nix-systems/x86_64-linux";
    tokyonight-theme = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    tokyonight-yazi-theme = {
      url = "github:kalidyasin/yazi-flavors";
      flake = false;
    };
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-extensions.url = "github:vicinaehq/extensions";
    vivaldi.url = "github:Hy4ri/vivaldi-snapshot-flake";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    yazi-plugin-fuzzy-search.url = "github:onelocked/fuzzy-search.yazi";
    yazi-plugins-repo = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    yazi-theme-everforest = {
      url = "github:Chromium-3-Oxide/everforest-medium.yazi";
      flake = false;
    };
  };
}
