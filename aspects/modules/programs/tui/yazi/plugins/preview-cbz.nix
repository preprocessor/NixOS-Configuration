{ inputs, ... }:
{
  tack.inputs.yazi-plugin-cbz = {
    url = "gh:AminurAlam/yazi-plugins";
    type = "fetch";
    group = "yazi";
  };

  exo.core =
    { pkgs, lib, ... }:
    let
      preview-cbz = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "preview-cbz";
        version = "0.67";

        src = lib.cleanSourceWith {
          src = inputs.yazi-plugin-cbz + "/preview-cbz.yazi";
          filter = name: _: (baseNameOf name == "main.lua");
        };
      };
    in
    {
      my.yazi.plugins = { inherit preview-cbz; };

      my.yazi.settings = {
        plugin.prepend_previewers = [
          {
            url = "*.cb{z,r}";
            run = "preview-cbz";
          }
        ];

        plugin.prepend_preloaders = [
          {
            url = "*.cb{z,r}";
            run = "preview-cbz";
          }
        ];
      };
    };
}
