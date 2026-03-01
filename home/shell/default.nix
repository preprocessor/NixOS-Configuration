{ ... }:
{
  imports = [
    ./fish.nix
    ./lazygit.nix
    ./starship.nix
  ];

  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  programs = {
    nix-your-shell = {
      enable = true;
      enableFishIntegration = true;
    };

    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;

      settings = {
        filter_mode = "directory";
        enter_accept = true;
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    yazi = {
      enable = true;
      shellWrapperName = "y";
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
}
