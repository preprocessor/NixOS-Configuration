{
  w.shell =
    { pkgs, config, ... }:
    {
      my.yazi.plugins = {
        inherit (pkgs.yaziPlugins) lazygit;
      };

      my.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [
            "g"
            "l"
          ] "plugin lazygit" "Open lazygit")
        ];
      };
    };
}
