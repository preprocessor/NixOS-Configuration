{ lib, ... }:
{
  flake.options.const = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf lib.types.unspecified;
    default = {
      stateVersion = "25.11";
      username = "wyspr";
      homedir = "/home/wyspr";
    };
  };
}
