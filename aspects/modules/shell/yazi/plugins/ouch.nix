{
  exo.core =
    { pkgs, ... }:
    {
      my.yazi.plugins = {
        inherit (pkgs.yaziPlugins) ouch;
      };

      my.yazi.settings = {
        plugin.prepend_previewers = [
          {
            mime = "application/{tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch --show-file-icons";
          }
          {
            url = "*.{zip,gzip}";
            run = "ouch --show-file-icons";
          }
        ];
      };

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
