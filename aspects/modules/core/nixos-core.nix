{
  tack.inputs.nixos-core.url = "gh:manic-systems/nixos-core/refs/tags/v1.0.1";

  perSystem =
    { packages', ... }:
    {
      remotePackages = { inherit (packages') nixos-core; };
    };

  exo.core =
    { inputs, ... }:
    {
      imports = [ inputs.nixos-core.nixosModules.default ];
      system.nixos-core.enable = true;
    };
}
