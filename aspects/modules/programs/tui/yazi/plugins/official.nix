{
  tack.inputs.yazi-plugins = {
    url = "gh:yazi-rs/plugins";
    group = "yazi";
    type = "fetch";
  };

  exo.core =
    {
      inputs,
      meta,
      pkgs,
      lib,
      ...
    }:
    {
      my.yazi.plugins =
        lib.genAttrs
          [
            "toggle-pane"
            "piper"
            "chmod"
            "git"
            "compress"
            "smart-filter"
            "smart-enter"
          ]
          (
            pname:
            pkgs.yaziPlugins.mkYaziPlugin {
              inherit pname;
              version = meta.yazi-plugins.rev;
              src = "${inputs.yazi-plugins}/${pname}.yazi";
              postPatch =
                lib.optionalString (pname == "compress") # bash
                  ''
                    substituteInPlace form.lua \
                      --replace-fail ':set("rounded")' ':set("plain")'
                  '';
            }
          );
    };
}
