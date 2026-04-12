{
  inputs,
  lib,
  self,
  ...
}:
{
  flake-file.inputs.hjem.url = "github:feel-co/hjem";

  flake.modules.nixos.default = {
    imports = [
      inputs.hjem.nixosModules.default
      (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" self.const.username ])
    ];

    hjem.clobberByDefault = true;
  };
}
