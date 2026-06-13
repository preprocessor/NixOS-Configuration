{
  w.default = {
    programs.direnv = {
      enable = true;
      silent = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
