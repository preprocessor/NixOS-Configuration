{
  envoy.extra-metadata.github = "boydaihungst/file-extra-metadata.yazi";

  w.shell =
    { envoy, pkgs, ... }:
    {
      custom.programs.yazi.plugins = {
        extra-metadata = pkgs.yaziPlugins.mkYaziPlugin {
          inherit (envoy.extra-metadata) pname version src;
        };
      };

      custom.programs.yazi.settings = {
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
