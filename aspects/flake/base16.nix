{ lib, ... }@top:
{
  options.schemes = lib.mkOption {
    type = lib.types.attrsOf lib.types.attrs;
    description = "A set of base16/24 colorschemes";
  };

  config = {
    tack.inputs.base16.url = "gh:senchopens/base16.nix";

    exo.skeleton =
      {
        constants,
        config,
        inputs,
        pkgs,
        ...
      }:
      {
        options.scheme = lib.mkOption {
          type = lib.types.enum (lib.attrNames top.config.schemes);
          default = "magi";
          description = "Choose the system colorscheme.";
        };

        config._module.args.scheme = (inputs.base16.lib pkgs).mkSchemeAttrs (
          {
            slug = config.scheme;
            scheme = config.scheme;
            author = constants.username;
          }
          // top.config.schemes.${config.scheme}
        );
      };
  };
}
