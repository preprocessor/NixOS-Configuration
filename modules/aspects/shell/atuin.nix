{
  flake.modules.homeManager.default = {
    programs.atuin = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;

      settings = {
        filter_mode = "directory";
        enter_accept = true;
      };
    };
  };
}
