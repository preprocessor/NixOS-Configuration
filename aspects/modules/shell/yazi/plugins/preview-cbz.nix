{ inputs, ... }:
{
  tack.yazi-plugins = {
    url = "gh:AminurAlam/yazi-plugins";
    type = "fetch";
  };

  w.default =
    { pkgs, lib, ... }:
    let
      preview-cbz = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "preview-cbz";
        version = "0.67";

        src = lib.cleanSourceWith {
          src = inputs.yazi-plugins + "/preview-cbz.yazi";
          filter = name: type: (baseNameOf name == "main.lua");
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
