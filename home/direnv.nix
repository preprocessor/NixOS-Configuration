{ ... }:
{
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
}
