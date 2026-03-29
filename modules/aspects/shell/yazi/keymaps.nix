{ self, ... }:
{
  flake.modules.homeManager.default = {
    programs.yazi = {
      keymap = {
        mgr.prepend_keymap = [
          {
            on = [
              "g"
              "m"
            ];
            run = "cd /run/media/wyspr/";
            desc = "Go to Media";
          }
          {
            on = [
              "g"
              "r"
            ];
            run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
            desc = "Go to git root";
          }
          {
            on = [
              "g"
              "n"
            ];
            run = "cd ${self.const.cfgdir}";
            desc = "Go to NixOS Configuration";
          }
          {
            on = [
              "b"
              "y"
            ];
            run = [
              ''shell -- for path in %s; do echo "file://$path"; done | wl-copy -t text/uri-list''
            ];
            desc = "Copy to clipboard";
          }
        ];
      };
    };
  };
}
