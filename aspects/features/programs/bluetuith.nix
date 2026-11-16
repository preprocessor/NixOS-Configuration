{
  modules.features.bluetooth = { pkgs, ... }: {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          AutoEnable = true;
        };
      };
    };

    hj.packages = [ pkgs.bluetuith ];
  };

  modules.features.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    lib.mkIf config.hardware.bluetooth.enable {
      my.xdg.desktopTuiEntries."Bluetuith" = {
        package = pkgs.bluetuith;
        width = 1200;
        height = 600;
      };
    };
}
