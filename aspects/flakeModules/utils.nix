{ lib, ... }:
let
  utilOption = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };
in
{
  options.utils = utilOption;

  config.modules.core = {
    options.utils = utilOption;
  };
}
