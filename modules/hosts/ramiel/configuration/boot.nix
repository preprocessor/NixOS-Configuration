{
  flake.modules.nixos.ramiel =
    { pkgs, ... }:
    {
      # Bootloader.

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };

        initrd.systemd.enable = true;
        plymouth = {
          enable = true;
          theme = "rings";
          themePackages = with pkgs; [
            # By default we would install all themes
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "rings" ];
            })
          ];
        };
        consoleLogLevel = 3;
        loader.timeout = 0;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
          "systemd.show_status=auto"
        ];
      };
    };
}
