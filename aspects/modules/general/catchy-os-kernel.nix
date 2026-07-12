{
  tack.nix-cachyos-kernel = {
    url = "gh:xddxdd/nix-cachyos-kernel/release";
    exclude_follow = [ "nixpkgs" ];
  };

  w.default =
    { inputs', ... }:
    {
      nix.settings = {
        substituters = [ "https://attic.xuyh0120.win/lantian" ];
        trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
      };

      boot.kernelPackages =
        inputs'.nix-cachyos-kernel.legacyPackages.linuxPackages-cachyos-bore-lto-x86_64-v4;

      _file = ./catchy-os-kernel.nix;
    };
}
