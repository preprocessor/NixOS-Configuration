{
  tack.inputs.nixos-core = {
    url = "gh:manic-systems/nixos-core";
    group = "nix";
  };

  perSystem =
    { packages', ... }:
    {
      remotePackages = { inherit (packages') nixos-core; };
    };

  modules.core =
    { inputs, ... }:
    {
      imports = [ inputs.nixos-core.nixosModules.default ];
      system.nixos-core.enable = true;
    };
}
