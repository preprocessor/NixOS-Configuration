{
  w.desktop = {
    wrappers.niri.settings = {
      binds =
        let
          set = _: { };
        in
        {

          "Mod+Alt+L" = _: {
            content.spawn = "swaylock";
            props.hotkey-overlay-title = "Lock the Screen: swaylock";
          };

          "Mod+Tab" = _: {
            content.toggle-overview = set;
            props.repeat = false;
          };

          # The following binds move the focused window in and out of a column.
          # If the window is alone, they will consume it into the nearby column to the side.
          # If the window is already in a column, they will expel it out.
          "Mod+BracketLeft".consume-or-expel-window-left = set;
          "Mod+BracketRight".consume-or-expel-window-right = set;

          # Consume one window from the right to the bottom of the focused column.
          "Mod+Comma".consume-window-into-column = set;
          # Expel the bottom window from the focused column to the right.
          "Mod+Period".expel-window-from-column = set;

          # Applications such as remote-desktop clients and software KVM switches may
          # request that niri stops processing the keyboard shortcuts defined here
          # so they may, for example, forward the key presses as-is to a remote machine.
          # It's a good idea to bind an escape hatch to toggle the inhibitor,
          # so a buggy application can't hold your session hostage.
          #
          # The allow-inhibiting=false property can be applied to other binds as well,
          # which ensures niri always processes them, even when an inhibitor is active.
          "Mod+Escape" = _: {
            content.toggle-keyboard-shortcuts-inhibit = set;
            props.allow-inhibiting = false;
          };

          # Powers off the monitors. To turn them back on, do any input like
          # moving the mouse or pressing any other key.
          "Mod+Shift+P".power-off-monitors = set;
        };
    };
  };
}
