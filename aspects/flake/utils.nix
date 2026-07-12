{ lib, ... }:
{
  imports = [ (lib.mkAliasOptionModule [ "w" ] [ "nixos" "modules" ]) ];

  options.utils = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config = {
    w.default = {
      options.utils = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = { };
      };
    };
  };
}
