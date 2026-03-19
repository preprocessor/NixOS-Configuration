{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
        enableBashIntegration = true;
        enableFishIntegration = true;

        plugins = {
          lazygit = pkgs.yaziPlugins.lazygit;
        };

        # settings = {
        #
        # };

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
