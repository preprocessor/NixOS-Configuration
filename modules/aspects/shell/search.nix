{
  flake.modules.homeManager.default =
    {
      pkgs,
      osConfig,
      lib,
      ...
    }:
    let
      scheme = osConfig.scheme;
    in
    {
      home.packages = with pkgs; [
        fd # better find
        ripgrep
      ];

      stylix.targets.fzf.enable = true;

      programs.fzf = {
        enable = true;
        # colors = {
        #   bg = "#${scheme.base00}";
        #   "bg+" = "#${scheme.base04}";
        #   fg = "#${scheme.base05}";
        #   "fg+" = "#${scheme.green}";
        #   hl = "#${scheme.red}";
        #   "hl+" = "#${scheme.red}";
        #   gutter = "#${scheme.base04}";
        #   separator = "#${scheme.base04}";
        #   border = "#${scheme.base04}";
        #   disabled = "#${scheme.base03}";
        #   info = "#${scheme.blue}";
        #   header = "#${scheme.base03}";
        #   marker = "#${scheme.green}";
        #   prompt = "#${scheme.green}";
        #   pointer = "#${scheme.green}";
        #   spinner = "#${scheme.yellow}";
        # };
      };

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
