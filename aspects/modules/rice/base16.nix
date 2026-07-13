{ inputs, ... }:
{
  tack.base16.url = "gh:senchopens/base16.nix";

  exo.skeleton =
    {
      config,
      theme,
      lib,
      ...
    }:
    {
      imports = [ inputs.base16.nixosModule ];

      options.theme = {
        variant = lib.mkOption {
          type = lib.types.enum [
            "light"
            "dark"
          ];
          default = "light";
          description = "Choose between the light and dark theme variant.";
        };

        light = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Light theme options.";
        };

        dark = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Dark theme options.";
        };
      };

      config =
        let
          scheme = config.theme.${theme};
        in
        {
          inherit scheme;

          _module.args = {
            inherit (config) scheme;
          };
        };
    };

  _file = ./base16.nix;
}
