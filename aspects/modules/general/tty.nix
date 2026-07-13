{
  exo.core =
    { scheme, ... }:
    {
      console.colors = with scheme; [
        base00-hex
        red
        green
        yellow
        blue
        magenta
        cyan
        base05-hex
        base03-hex
        red
        green
        yellow
        blue
        magenta
        cyan
        base07-hex
      ];

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        initrd.systemd.enable = true;
        consoleLogLevel = 3;
        loader.timeout = 1;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
          "systemd.show_status=auto"
        ];
      };
    };

}
