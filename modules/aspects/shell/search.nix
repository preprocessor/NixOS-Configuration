{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        fd # better find
        ripgrep
      ];

      stylix.targets.fzf.enable = true;
      programs.fzf.enable = true;

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
