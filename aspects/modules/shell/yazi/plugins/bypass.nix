{
  w.shell =
    { pkgs, config, ... }:
    {
      my.yazi.plugins = {
        inherit (pkgs.yaziPlugins) bypass;
      };

      my.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "h" ] "plugin bypass reverse" "Enter the child directory, or open the file")
        ];
      };
    };
}
