{
  flake.modules.nixos.desktop = {
    custom.programs.niri.settings = {
      # extraConfig = ''
      #   spawn-sh-at-startup "awww-daemon"
      #   spawn-sh-at-startup "wl-clip-persist --clipboard regular --reconnect-tries 0"
      #   spawn-sh-at-startup "wl-paste --type text --watch cliphist store"
      # '';
      spawn-at-startup = [
        "wl-clip-persist --clipboard regular --reconnect-tries 0"
        "wl-paste --type text --watch cliphist store"
      ];

      hotkey-overlay.skip-at-startup = null;
    };
  };
}
