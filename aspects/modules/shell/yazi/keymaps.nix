{
  w.shell =
    {
      constants,
      pkgs,
      config,
      ...
    }:
    {
      wrappers.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "g" "m" ] "cd /run/media/wyspr/" "Go to Media")
          (yaziKeymap [ "g" "r" ] ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'' "Go to git root")
          (yaziKeymap [ "g" "n" ] "cd ${constants.cfgdir}" "Go to NixOS Configuration")

          (yaziKeymap [ "H" ] "back" "Go to previous directory")
          (yaziKeymap [ "L" ] "forward" "Go to next directory")

          (yaziKeymap [ "i" "c" ]
            ''shell --block -- ${pkgs.mcat}/bin/mcat ls "$PWD" --hyprlink --kitty --ls-opts 'height=10%,items_per_row=6'; echo -e "\nPress Enter to return to Yazi..."; read ''
            "mcat preview of cwd"
          )

          (yaziKeymap [ "b" "y" ]
            ''shell -- for path in %s; do echo "file://$path"; done | wl-copy -t text/uri-list''
            "Copy to clipboard"
          )
        ];
      };

      _file = ./keymaps.nix;
    };
}
