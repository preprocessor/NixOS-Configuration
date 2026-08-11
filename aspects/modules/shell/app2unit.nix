{
  exo.mods.desktop.my.app2unit.enable = true;

  exo.skeleton =
    {
      config,
      inputs,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.app2unit;
    in
    {
      options.my.app2unit = {
        enable = lib.mkEnableOption { };

        package = lib.mkOption {
          default = (
            pkgs.app2unit.overrideAttrs (
              final: prev: {
                src = inputs.app2unit;
              }
            )
          );
        };
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
