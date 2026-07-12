{ lib, ... }:
{
  imports = [ (lib.mkAliasOptionModule [ "w" ] [ "nixos" "modules" ]) ];

  # Integral options to de-parted
  options = {
    systems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "x86_64-linux" ];
    };

    flake = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = { };
    };

    perSystem = lib.mkOption {
      type = lib.types.deferredModule;
      default = { };
    };
  };
}
