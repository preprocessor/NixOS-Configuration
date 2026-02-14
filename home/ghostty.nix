{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;

    installBatSyntax = true;
    installVimSyntax = true;

    settings = {
      theme = "Gruvbox Light";
    };
  };
}
