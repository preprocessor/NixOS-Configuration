{
  envoy.extra-metadata.github = "boydaihungst/file-extra-metadata.yazi";

  w.shell =
    { envoy, pkgs, ... }:
    let
      extra-metadata = pkgs.yaziPlugins.mkYaziPlugin {
        inherit (envoy.extra-metadata) pname version src;
      };
    in
    {
      wrappers.yazi.plugins = {
        inherit extra-metadata;
      };

      wrappers.yazi.settings = {
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
