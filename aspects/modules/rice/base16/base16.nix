{ inputs, ... }:
{
  inputs.base16.url = "github:senchopens/base16.nix";

  envoy.schemes.github = "tinted-theming/schemes";
  # Browse themes at: https://tinted-theming.github.io/tinted-gallery/

  w.default =
    {
      config,
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
          cfg = config.theme;
          scheme = cfg.${cfg.variant};
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
