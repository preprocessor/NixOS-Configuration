{
  flake.hjemModules.app2unit =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.app2unit;
    in
    {

      options.my.app2unit = {
        enable = lib.mkEnableOption { } // {
          default = true;
        };

        package = lib.mkPackageOption pkgs "app2unit" { };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];

        hj.environment.sessionVariables = {
          APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
          APP2UNIT_TYPE = "service";
          # This is a workaround to set NIXOS_OZONE_WL as described in https://wiki.nixos.org/wiki/Wayland#Electron_and_Chromium
          NIXOS_OZONE_WL = "1";
        };
      };
    };
}
