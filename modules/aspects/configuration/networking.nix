{
  flake.modules.nixos.default = {
    # Enable networking
    networking.networkmanager.enable = true;
  };

  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.wgnord ];
    };
}
