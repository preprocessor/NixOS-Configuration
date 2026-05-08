{
  w.desktop = {
    wrappers.niri.settings = {
      spawn-at-startup = [
        "wl-clip-persist --clipboard regular"
        ''cclipd -s 2 -t "image/png" -t "image/*" -t "text/plain;charset=utf-8" -t "text/*" -t "*"''
        "dbus-daemon --session --address=unix:path=$XDG_RUNTIME_DIR/bus"
      ];

      hotkey-overlay.skip-at-startup = _: { };
    };

    _file = "niri/startup.nix";
  };
}
