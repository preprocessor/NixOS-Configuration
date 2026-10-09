{ inputs, ... }:
{
  tack.inputs.extra-metadata = {
    url = "gh:boydaihungst/file-extra-metadata.yazi";
    type = "fetch";
    group = "yazi";
  };

  exo.core =
    { pkgs, ... }:
    {
      my.yazi.plugins = {
        extra-metadata = pkgs.yaziPlugins.mkYaziPlugin {
          src = inputs.extra-metadata;
          pname = "yazi-extra-metadata";
          version = "git";
        };
      };

      my.yazi.settings = {
        spotters = [
          {
            url = "*";
            run = "extra-metadata";
          }
        ];
      };

      _file = ./extra-metadata.nix;
    };
}
