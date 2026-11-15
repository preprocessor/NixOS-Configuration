{ withSystem, ... }:
let
  mkSystem =
    name:
    {
      system,
      modules ? [ ],
      extraSpecialArgs ? { },
    }:
    withSystem system (
      {
        packages',
        rootPath,
        inputs',
        inputs,
        self',
        meta,
        self,
        ...
      }:
      let
        inherit (inputs.nixpkgs) lib;
        modulesPath = "${inputs.nixpkgs}/nixos/modules";
        baseModules = import "${modulesPath}/module-list.nix";
        userModules = modules;

        eval = lib.evalModules {
          class = "nixos";

          specialArgs = {
            inherit
              inputs'
              inputs
              meta
              modulesPath
              packages'
              self'
              self
              rootPath
              system
              ;
          }
          // extraSpecialArgs;

          modules =
            baseModules
            ++ userModules
            ++ [
              {
                config = {
                  _module.args = {
                    inherit baseModules;
                    modules = userModules;
                  };

                  networking.hostName = lib.mkDefault name;
                  nixpkgs.hostPlatform = lib.mkDefault system;
                  nixpkgs.flake.source = inputs.nixpkgs.outPath;
                };
              }
            ];
        };
      in
      eval
      // {
        inherit (eval.config._module.args) pkgs;
        inherit (inputs.nixpkgs) lib;
      }
    );
in
{
  config._module.args = { inherit mkSystem; };
}
