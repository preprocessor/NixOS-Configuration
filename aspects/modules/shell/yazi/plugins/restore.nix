{
  w.shell =
    { config, pkgs, ... }:
    {
      custom.programs.yazi.plugins = {
        inherit (pkgs.yaziPlugins) restore;
      };

      custom.programs.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "u" ] "plugin restore" "Restore last deleted files/folders")
          (yaziKeymap [ "U" ] "plugin restore -- --interactive" "Restore deleted files/folders (Interactive)")
        ];
      };
    };
}
