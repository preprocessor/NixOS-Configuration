{
  w.shell =
    { pkgs, ... }:
    {
      wrappers.yazi.plugins = {
        inherit (pkgs.yaziPlugins) smart-filter;
      };

      wrappers.yazi.keymap = {
        mgr.prepend_keymap = [
          {
            on = "f";
            run = "plugin smart-filter";
            desc = "Smart filter";
          }
        ];
      };
    };
}
