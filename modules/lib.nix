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
    hm = modules: {
      home-manager.users.${self.const.username}.imports = modules;
    };

    mkSystem =
      {
        nixosModules,
        homeModules ? [ ],
        configuration ? { },
      }:
      let
        nixosWithDefault = nixosModules ++ [ self.modules.nixos.default ];
        homeWithDefault = homeModules ++ [ self.modules.homeManager.default ];
      in
      inputs.nixpkgs.lib.nixosSystem {
        modules = nixosWithDefault ++ lib.optional (homeWithDefault != [ ]) (self.lib.hm homeWithDefault);
      }
      // configuration;

    mkPackages =
      {
        nixosPackages ? [ ],
        homePackages ? [ ],
      }:
      {
        environment.systemPackages = nixosPackages;
        home-manager.users."${self.const.username}".home.packages = homePackages;
      };
  };
}
