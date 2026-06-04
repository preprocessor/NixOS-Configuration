{
  w.shell =
    { pkgs, ... }:
    {
      wrappers.yazi.plugins = {
        inherit (pkgs.yaziPlugins) ouch;
      };

      wrappers.yazi.settings = {
        plugin.prepend_previewers = [
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch --show-file-icons";
          }
        ];
      };

      wrappers.yazi.keymap = {
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
