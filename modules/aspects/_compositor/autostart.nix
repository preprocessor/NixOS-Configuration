{
  flake.modules.homeManager.desktop.wayland.windowManager.mango.autostart_sh = /* bash */ ''
    wl-clip-persist --clipboard regular --reconnect-tries 0 &
    wl-paste --type text --watch cliphist store &
  '';
}
