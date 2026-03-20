{ inputs, ... }:
{
  flake-file.inputs.direnv-instant = {
    url = "github:Mic92/direnv-instant";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.homeManager.default = {
    imports = [ inputs.direnv-instant.homeModules.direnv-instant ];

    programs = {
      direnv = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };

      direnv-instant = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
