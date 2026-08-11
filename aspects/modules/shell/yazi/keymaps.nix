{
  exo.core =
    {
      constants,
      pkgs,
      config,
      ...
    }:
    {
      my.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "g" "m" ] "cd /run/media/wyspr/" "Go to Media")
          (yaziKeymap [ "g" "r" ] ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'' "Go to git root")
          (yaziKeymap [ "g" "n" ] "cd ${constants.cfgdir}" "Go to NixOS Configuration")
          (yaziKeymap [
            "g"
            "s"
          ] "cd ${config.hj.xdg.data.directory}/Steam/steamapps/common" "Go to Steam Apps")

          (yaziKeymap [ "H" ] "back" "Go to previous directory")
          (yaziKeymap [ "L" ] "forward" "Go to next directory")

          (yaziKeymap [ "b" "y" ]
            ''shell -- for path in %s; do echo "file://$path"; done | wl-copy -t text/uri-list''
            "Copy to clipboard"
          )
        ];
      };

      _file = ./keymaps.nix;
    };
}
