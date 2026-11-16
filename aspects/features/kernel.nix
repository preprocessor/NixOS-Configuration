{
  modules.core = { pkgs, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };

  modules.host.xyz = { modulesPath, ... }: {
    imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
    boot.initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
      "sd_mod"
    ];
    boot.kernelModules = [ "kvm-intel" ];
  };

  modules.features.desktop =
    { pkgs, constants, ... }:
    {
      environment.systemPackages = [ pkgs.ddcutil ];

      services.udev.extraRules = ''KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"'';

      boot.kernelModules = [ "i2c-dev" ];
      users.groups.i2c = { };
      users.users.${constants.username}.extraGroups = [ "i2c" ];
    };
}
