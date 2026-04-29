{ inputs, lib, ... }:
{
  ff.flake-parts.url = "github:hercules-ci/flake-parts";

  imports = [
    inputs.flake-parts.flakeModules.modules
    (lib.mkAliasOptionModule [ "w" ] [ "flake" "modules" "nixos" ])
  ];

  systems = [ "x86_64-linux" ];

  perSystem =
    { system, ... }:
    let
      # Configure Nix to allow unfree packages.
      config.allowUnfree = true;
      pkgs = import inputs.nixpkgs { inherit system config; };
    in
    {
      # initialize the pkgs for perSystem to be the patched nixpkgs
      _module.args = { inherit pkgs; };

      formatter = pkgs.alejandra;

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
