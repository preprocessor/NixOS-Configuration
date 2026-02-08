{ config, pkgs, ... }:
{

  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "ramiel"; # Define your hostname.

}
