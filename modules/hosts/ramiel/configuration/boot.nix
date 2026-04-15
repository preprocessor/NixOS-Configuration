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
        plymouth =
          let
            theme = "pixels";
          in
          {
            inherit theme;
            enable = true;
            themePackages = with pkgs; [
              # By default we would install all themes
              (adi1090x-plymouth-themes.override {
                selected_themes = [ theme ];
              })
            ];
          };
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
