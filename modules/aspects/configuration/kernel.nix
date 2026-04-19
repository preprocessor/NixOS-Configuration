{ self, inputs, ... }:
{
  ff.nix-cachyos-kernel = {
    url = "github:xddxdd/nix-cachyos-kernel/release";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-compat.follows = "flake-compat";
      flake-parts.follows = "flake-parts";
    };
  };

  w.default =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

      nix.settings.substituters = [
        "https://attic.xuyh0120.win/lantian"
        "https://cache.garnix.io"
      ];
      nix.settings.trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];

      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

      environment.systemPackages = with pkgs; [
        ddcutil
      ];

      services.udev.extraRules = ''
        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
      '';

      boot.kernelModules = [ "i2c-dev" ];
      users.groups.i2c = { };
      users.users.${self.const.username}.extraGroups = [ "i2c" ];
    };
}
