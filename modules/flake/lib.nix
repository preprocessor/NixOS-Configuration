{
  lib,
  self,
  inputs,
  ...
}:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {

    mkSystem =
      {
        nixosModules,
        homeModules ? [ ],
        configuration ? { },
      }:
      let
        nixosWithDefault = nixosModules ++ [ self.modules.nixos.default ];
      in
      inputs.nixpkgs.lib.nixosSystem {
        modules = nixosWithDefault;
      }
      // configuration;

    mkPackages =
      {
        nixosPackages ? [ ],
        homePackages ? [ ],
      }:
      {
        environment.systemPackages = nixosPackages;
      };
  };
}
