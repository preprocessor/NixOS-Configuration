{
  modules.features.desktop = {
    boot.loader.systemd-boot.enable = true;
    boot.kernelParams = [ "systemd.show_status=auto" ];
    boot.loader.efi.canTouchEfiVariables = true;
  };

  modules.hardware.xyz-vps = {
    # disko sets boot.loader.grub.devices from the EF02 partition.
    boot.loader.grub.enable = true;
  };

  modules.core = { scheme, ... }: {
    console.colors = with scheme.noHashtag; [
      base00
      red
      green
      yellow
      blue
      magenta
      cyan
      base05
      base03
      red
      green
      yellow
      blue
      magenta
      cyan
      base07
    ];

    boot = {
      consoleLogLevel = 3;
      loader.timeout = 1;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
      ];
    };
  };
}
