{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
    "aarch64-darwin"
  ];

  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.rocmSupport = true;
        # overlays = [
        # ];
      };
    in
    {
      # initialize the pkgs for perSystem to be the patched nixpkgs
      _module.args = { inherit pkgs; };

      formatter = pkgs.nixfmt;

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd
          cachix
          lorri
          niv
          nixfmt
          statix
          vulnix
          haskellPackages.dhall-nix
          lua51Packages.lua
          lua51Packages.luarocks
          lua-language-server
        ];
      };
    };

  # https://github.com/iynaix/dotfiles/blob/main/modules/flake-parts.nix
  # flake = {
  #   # expose top level flake options
  #   options = {
  #     patches = lib.mkOption {
  #       type = lib.types.anything;
  #       default = [ ];
  #       description = "Patches to be applied onto nixpkgs";
  #     };
  #
  #     wrapperModules = lib.mkOption {
  #       type = lib.types.attrs;
  #       default = { };
  #       description = "Wrapper modules";
  #     };
  #
  #     libCustom = lib.mkOption {
  #       type = lib.types.attrsOf lib.types.anything;
  #       default = { };
  #       description = "Custom library functions / utilities";
  #     };
  #   };
  # };
}
