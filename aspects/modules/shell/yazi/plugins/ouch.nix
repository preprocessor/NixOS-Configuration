{
  exo.core =
    { pkgs, ... }:
    {
      my.yazi.plugins = { inherit (pkgs.yaziPlugins) ouch; };

      my.yazi.keymap = {
        mgr.prepend_keymap = [
          {
            on = [ "C" ];
            run = "plugin ouch";
            desc = "Compress with ouch";
          }
        ];
      };
    };
}
