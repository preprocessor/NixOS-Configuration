{
  w.shell =
    {
      config,
      scheme,
      envoy,
      pkgs,
      lib,
      ...
    }:
    {
      wrappers.yazi.plugins = {
        inherit (pkgs.yaziPlugins) toggle-pane;
      };

      wrappers.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "[" ] "plugin toggle-pane min-parent" "Minimize left pane")
          (yaziKeymap [ "]" ] "plugin toggle-pane min-preview" "Minimize right pane")
          (yaziKeymap [ "{" ] "plugin toggle-pane max-parent" "Maximize left pane")
          (yaziKeymap [ "}" ] "plugin toggle-pane max-preview" "Maximize right pane")
        ];
      };

      _file = ./toggle-pane.nix;
    };
}
