{ inputs, ... }:
{
  flake.modules.homeManager.default = {
    imports = [ inputs.worktrunk.homeModules.default ];
    programs.worktrunk = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
