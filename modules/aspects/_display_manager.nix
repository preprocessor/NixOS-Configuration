{
  flake.modules.nixos.default = {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "colormix";
        bigclock = "en";
        bigclock_12hr = true;
        numlock = true;
        box_title = " Login ";

        # colormix_col1 = 0x00FF0000
        # colormix_col2 = 0x000000FF
        # colormix_col3 = 0x20000000
      };
    };

    security.pam.services.ly.enableGnomeKeyring = true;
  };

}
