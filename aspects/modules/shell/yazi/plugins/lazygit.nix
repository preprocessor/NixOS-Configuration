{
  w.shell =
    { pkgs, config, ... }:
    {
      custom.programs.yazi.plugins = {
        inherit (pkgs.yaziPlugins) lazygit;
      };

      custom.programs.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [
            "g"
            "l"
          ] "plugin lazygit" "Open lazygit")
        ];
      };
    };
}
