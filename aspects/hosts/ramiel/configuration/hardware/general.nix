{ inputs, ... }:
{
  w.ramiel =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        inputs.nixos-hardware.nixosModules.common-pc
      ];

      hardware.bluetooth.enable = true;

      # services.g810-led.enable = true; # Logitech keyboard LED Controls
      services.udev = {
        packages = [ pkgs.g810-led ];

        extraRules = ''
          KERNEL=="hidraw*", ATTRS{idVendor}=="1001", ATTRS{idProduct}=="303a", MODE="0666"
        '';
      };
    };
}
