{
  w.shell =
    { pkgs, config, ... }:
    {
      wrappers.yazi.plugins = {
        inherit (pkgs.yaziPlugins) lazygit;
      };

      wrappers.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [
            "g"
            "l"
          ] "plugin lazygit" "Open lazygit")
        ];
      };
    };
}
