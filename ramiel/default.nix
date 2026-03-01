{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./river.nix
    inputs.base16.nixosModule
    inputs.stylix.nixosModules.stylix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.river.nixosModules.default
  ];

  networking.hostName = "ramiel"; # Define your hostname.
}
