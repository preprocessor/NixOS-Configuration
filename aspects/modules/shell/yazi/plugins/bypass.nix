{
  w.shell =
    { pkgs, config, ... }:
    {
      wrappers.yazi.plugins = {
        inherit (pkgs.yaziPlugins) bypass;
      };

      wrappers.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "h" ] "plugin bypass reverse" "Enter the child directory, or open the file")
        ];
      };
    };
}
