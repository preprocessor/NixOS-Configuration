{

  flake.modules.homeManager.default = {
    programs.nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
