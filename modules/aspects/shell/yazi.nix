{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    let
      everforest-yazi = pkgs.fetchFromGitHub {
        owner = "Chromium-3-Oxide";
        repo = "everforest-medium.yazi";
        rev = "3d5f8471fa6d5c2130d8a980b4ef48d8c5c8521d";
        hash = "sha256-FXg++wVSGrJZnYodzkS4eVIeQE1xm8o0urnoInqfP5g=";
      };
    in
    {
      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
        enableBashIntegration = true;
        enableFishIntegration = true;

        flavors = {
          everforest-medium = "${everforest-yazi}";
        };

        theme.flavor = {
          dark = "everforest-medium";
          light = "everforest-medium";
          use = "everforest-medium";
        };

        plugins = {
          lazygit = pkgs.yaziPlugins.lazygit;
        };

        settings = {

        };

        keymap = {
          mgr.prepend_keymap = [
            {
              on = [
                "g"
                "m"
              ];
              run = "cd /run/media/wyspr/";
              desc = "go to media";
            }
            {
              on = [
                "g"
                "l"
              ];
              run = "plugin lazygit";
              desc = "run lazygit";
            }
            {
              on = [
                "g"
                "r"
              ];
              run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
              desc = "git root";
            }
            {
              on = [
                "b"
                "y"
              ];
              run = [
                ''shell -- for path in %s; do echo "file://$path"; done | wl-copy -t text/uri-list''
              ];
              desc = "copy to clipboard";
            }
          ];
        };
      };
    };
}
