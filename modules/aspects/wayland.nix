{
  w.default =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        xwayland-satellite
        app2unit
        wl-clipboard
        wl-clip-persist
        cliphist
      ];

      hj.environment.sessionVariables = {
        APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
        APP2UNIT_TYPE = "service";
      };

      programs.uwsm.enable = true;
    };
}
