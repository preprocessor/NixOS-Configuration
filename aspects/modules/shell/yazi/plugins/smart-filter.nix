{
  w.shell =
    { pkgs, ... }:
    {
      my.yazi.plugins = {
        inherit (pkgs.yaziPlugins) smart-filter;
      };

      my.yazi.keymap = {
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
