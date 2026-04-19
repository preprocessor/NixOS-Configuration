{
  w.desktop = {
    custom.programs.niri.settings = {
      spawn-at-startup = [
        # "wl-clip-persist --clipboard regular --reconnect-tries 0"
        # "wl-paste --type text --watch cliphist store"
        "vicinae server"
      ];

      hotkey-overlay.skip-at-startup = _: { };
    };
  };
}
