{
  tack.inputs.nix-cachyos-kernel = {
    url = "gh:xddxdd/nix-cachyos-kernel/release";
    group = "gaming";
    exclude_follow = [ "nixpkgs" ];
  };

  perSystem = { inputs', ... }: {
    remotePackages.cachy-kernel =
      inputs'.nix-cachyos-kernel.legacyPackages.linuxPackages-cachyos-bore-lto-x86_64-v4;
  };

  exo.mods.gaming =
    { self', ... }:
    {
      nix.settings = {
        substituters = [ "https://cache.xinux.uz" ];
        trusted-public-keys = [ "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0=" ];
      };

      boot.kernelPackages = self'.packages.cachy-kernel;

      _file = ./catchy-os-kernel.nix;
    };
}
