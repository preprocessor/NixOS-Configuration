{
  w.ramiel =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "uas"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/0d6d999c-d55b-44c1-9f70-ba7fea4011a8";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-uuid/0d6d999c-d55b-44c1-9f70-ba7fea4011a8";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/8845-5658";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
