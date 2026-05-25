{ lib, ... }:
{
  options.utils = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  # config.utils = {};
}
