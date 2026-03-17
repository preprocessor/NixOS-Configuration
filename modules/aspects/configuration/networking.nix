{
  flake.modules.nixos.default = {
    # Enable networking
    networking.networkmanager.enable = true;
  };
}
