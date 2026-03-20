{ inputs, ... }:
{
  flake-file.inputs.worktrunk.url = "github:max-sixty/worktrunk";

  flake.modules.homeManager.default = {
    imports = [ inputs.worktrunk.homeModules.default ];
    programs.worktrunk = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
