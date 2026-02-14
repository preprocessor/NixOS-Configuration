{ config, pkgs, ... }:
{
  enable = true;
  enableBashIntegration = true;
  enableFishIntegration = true;
  enableZshIntegration = true;

  installBatSyntax = true;
  installVimSyntax = true;

  settings = {
    theme = "gruvbox-light";
  };
}
