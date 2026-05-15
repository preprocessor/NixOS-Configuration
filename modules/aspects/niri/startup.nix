{
  w.desktop =
    { pkgs, lib, ... }:
    {
      wrappers.niri.settings = {
        spawn-at-startup = [
          "wl-clip-persist --clipboard regular"
        ];

        hotkey-overlay.skip-at-startup = _: { };
      };

      _file = "niri/startup.nix";
    };
}
