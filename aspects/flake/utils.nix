{ lib, ... }:
{
  options.utils = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.utils = {
    otterResize =
      width: height: app:
      "niri msg action set-window-width ${toString width};niri msg action set-window-height ${toString height};sleep 0.025;niri msg action center-window;${app}";
  };
}
