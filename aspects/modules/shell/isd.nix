{
  exo.core =
    { config, pkgs, ... }:
    {
      hj.packages = [ pkgs.isd ];
      my.xdg.desktopEntries."isd".noDisplay = true;

      my.otter-launcher.modules =
        let
          spawn = config.utils.hyprSpawn;
        in
        [
          {
            description = "systemd";
            prefix = "isd";
            cmd = spawn 2100 1200 "isd" "isd";
          }
        ];
    };
}
