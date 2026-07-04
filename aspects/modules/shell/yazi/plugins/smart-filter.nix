{
  w.shell =
    { pkgs, ... }:
    {
      custom.programs.yazi.plugins = {
        inherit (pkgs.yaziPlugins) smart-filter;
      };

      custom.programs.yazi.keymap = {
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
