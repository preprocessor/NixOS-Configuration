{ self, lib, ... }:
{
  w.desktop =
    { pkgs, ... }:
    {
      custom.programs.niri.settings = {
        binds =
          let
            set = _: { };
            termExec =
              cmd:
              [
                "kitty"
                "-e"
              ]
              ++ (lib.flatten cmd);
          in
          {
            # Mod-Shift-/, which is usually the same as Mod-?,
            # shows a list of important hotkeys.
            "Mod+Shift+Slash".show-hotkey-overlay = set;

            # Suggested binds for running programs: terminal, app launcher, screen locker.
            "Mod+Return" = _: {
              content.spawn = [
                "kitty"
                "-1"
              ];
              props = {
                hotkey-overlay-title = "Open a Terminal: kitty";
                repeat = false;
              };
            };
            "Mod+Space" = _: {
              content.spawn = [
                # "tofi-drun | xargs --no-run-if-empty app2unit"
                "fuzzel"
              ];
              props.hotkey-overlay-title = "Open application launcher: fuzzel";
            };
            "Mod+Alt+Space" = _: {
              content.spawn-sh = [
                ""
                # "tofi-run | xargs --no-run-if-empty ghostty -e"
              ];
            };
            "Mod+V" = _: {
              content.spawn = [
                "vicinae"
                "vicinae://extensions/vicinae/clipboard/history"
              ];
              props.hotkey-overlay-title = "Open clipboard manager: vicinae";
            };
            "Super+Alt+L" = _: {
              content.spawn = "swaylock";
              props.hotkey-overlay-title = "Lock the Screen: swaylock";
            };

            "Mod+E".spawn = [
              "nemo"
              "${self.const.homedir}/Downloads"
            ];
            "Mod+Shift+E".spawn = termExec [
              "yazi"
              "${self.const.homedir}/Downloads"
            ];

            # Example volume keys mappings for PipeWire & WirePlumber.
            # The allow-when-locked=true property makes them work even when the session is locked.
            # Using spawn-sh allows to pass multiple arguments together with the command.
            # "-l 1.0" limits the volume to 100%.
            "XF86AudioRaiseVolume" = _: {
              content.spawn = [
                "wpctl"
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "0.1+"
                "-l"
                "1.0"
              ];
              props.allow-when-locked = true;
            };
            "XF86AudioLowerVolume" = _: {
              content.spawn = [
                "wpctl"
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "0.1-"
              ];
              props.allow-when-locked = true;
            };
            "XF86AudioMute" = _: {
              content.spawn = [
                "wpctl"
                "set-mute"
                "@DEFAULT_AUDIO_SINK@"
                "toggle"
              ];
              props.allow-when-locked = true;
            };

            # Example media keys mapping using playerctl.
            # This will work with any MPRIS-enabled media player.
            "XF86AudioPlay" = _: {
              content.spawn = [
                "playerctl"
                "play-pause"
              ];
              props.allow-when-locked = true;
            };
            "XF86AudioStop" = _: {
              content.spawn = [
                "playerctl"
                "stop"
              ];
              props.allow-when-locked = true;
            };
            "XF86AudioPrev" = _: {
              content.spawn = [
                "playerctl"
                "previous"
              ];
              props.allow-when-locked = true;
            };
            "XF86AudioNext" = _: {
              content.spawn = [
                "playerctl"
                "next"
              ];
              props.allow-when-locked = true;
            };

            # Example brightness key mappings for brightnessctl.
            # You can use regular spawn with multiple arguments too (to avoid going through = "sh"),
            # but you need to manually put each argument in separate = "" quotes.
            "XF86MonBrightnessUp" = _: {
              content.spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "+10%"
              ];
              props.allow-when-locked = true;
            };
            "XF86MonBrightnessDown" = _: {
              content.spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "10%-"
              ];
              props.allow-when-locked = true;
            };

            "Mod+Backspace" = _: {
              content.close-window = set;
              props.repeat = false;
            };

            "Mod+H".focus-column-left = set;
            "Mod+J".focus-window-or-workspace-down = set;
            "Mod+K".focus-window-or-workspace-up = set;
            "Mod+L".focus-column-right = set;

            "Mod+Ctrl+H".move-column-left = set;
            "Mod+Ctrl+J".move-window-down-or-to-workspace-down = set;
            "Mod+Ctrl+K".move-window-up-or-to-workspace-up = set;
            "Mod+Ctrl+L".move-column-right = set;

            "Mod+Home".focus-column-first = set;
            "Mod+End".focus-column-last = set;
            "Mod+Ctrl+Home".move-column-to-first = set;
            "Mod+Ctrl+End".move-column-to-last = set;

            "Mod+Shift+H".focus-monitor-left = set;
            "Mod+Shift+J".focus-monitor-down = set;
            "Mod+Shift+K".focus-monitor-up = set;
            "Mod+Shift+L".focus-monitor-right = set;

            "Mod+Ctrl+Left".move-window-to-monitor-left = set;
            "Mod+Ctrl+Down".move-window-to-monitor-down = set;
            "Mod+Ctrl+Up".move-window-to-monitor-up = set;
            "Mod+Ctrl+Right".move-window-to-monitor-right = set;

            "Mod+Ctrl+Page_Down".move-column-to-workspace-down = set;
            "Mod+Ctrl+Page_Up".move-column-to-workspace-up = set;

            "Mod+Shift+Page_Down".move-workspace-down = set;
            "Mod+Shift+Page_Up".move-workspace-up = set;

            # You can bind mouse wheel scroll ticks using the following syntax.
            # These binds will change direction based on the natural-scroll setting.
            #
            # To avoid scrolling through workspaces really fast, you can use
            # the cooldown-ms property. The bind will be rate-limited to this value.
            # You can set a cooldown on any bind, but it's most useful for the wheel.
            "Mod+WheelScrollDown" = _: {
              content.focus-workspace-down = set;
              props.cooldown-ms = 150;
            };
            "Mod+WheelScrollUp" = _: {
              content.focus-workspace-up = set;
              props.cooldown-ms = 150;
            };
            "Mod+Ctrl+WheelScrollDown" = _: {
              content.move-column-to-workspace-down = set;
              props.cooldown-ms = 150;
            };
            "Mod+Ctrl+WheelScrollUp" = _: {
              content.move-column-to-workspace-up = set;
              props.cooldown-ms = 150;
            };

            "Mod+WheelScrollRight".focus-column-right = set;
            "Mod+WheelScrollLeft".focus-column-left = set;
            "Mod+Ctrl+WheelScrollRight".move-column-right = set;
            "Mod+Ctrl+WheelScrollLeft".move-column-left = set;

            # You can refer to workspaces by index. However, keep in mind that
            # niri is a dynamic workspace system, so these commands are kind of
            # "best effort". Trying to refer to a workspace index bigger than
            # the current workspace count will instead refer to the bottommost
            # (empty) workspace.
            #
            # For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
            # will all refer to the 3rd workspace.
            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;
            "Mod+Ctrl+1".move-window-to-workspace = 1;
            "Mod+Ctrl+2".move-window-to-workspace = 2;
            "Mod+Ctrl+3".move-window-to-workspace = 3;
            "Mod+Ctrl+4".move-window-to-workspace = 4;
            "Mod+Ctrl+5".move-window-to-workspace = 5;
            "Mod+Ctrl+6".move-window-to-workspace = 6;
            "Mod+Ctrl+7".move-window-to-workspace = 7;
            "Mod+Ctrl+8".move-window-to-workspace = 8;
            "Mod+Ctrl+9".move-window-to-workspace = 9;

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

            "Mod+R".switch-preset-column-width = set;
            # Cycling through the presets in reverse order is also possible.
            # Mod+R { switch-preset-column-width-back; }
            "Mod+Shift+R".switch-preset-window-height = set;
            "Mod+Ctrl+R".reset-window-height = set;
            "Mod+F".maximize-column = set;
            "Mod+Shift+F".fullscreen-window = set;

            # While maximize-column leaves gaps and borders around the window,
            # maximize-window-to-edges doesn't: the window expands to the edges of the screen.
            # This bind corresponds to normal window maximizing,
            # e.g. by double-clicking on the titlebar.
            "Mod+M".maximize-window-to-edges = set;

            # Expand the focused column to space not taken up by other fully visible columns.
            # Makes the column = "fill the rest of the space".
            "Mod+Ctrl+F".expand-column-to-available-width = set;

            "Mod+C".center-column = set;

            # Center all fully visible columns on screen.
            "Mod+Ctrl+C".center-visible-columns = set;

            # Finer width adjustments.
            # This command can also:
            # * set width in pixels: "1000"
            # * adjust width in pixels: "-5" or = "+5"
            # * set width as a percentage of screen width: "25%"
            # * adjust width as a percentage of screen width: "-10%" or = "+10%"
            # Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
            # set-column-width = "100" will make the column occupy 200 physical screen pixels.
            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";

            # Finer height adjustments when in column with other windows.
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            # Move the focused window between the floating and the tiling layout.
            "Mod+Backslash".toggle-window-floating = set;
            "Mod+Shift+Backslash".switch-focus-between-floating-and-tiling = set;

            # Toggle tabbed column display mode.
            # Windows in this column will appear as vertical tabs,
            # rather than stacked on top of each other.
            "Mod+W".toggle-column-tabbed-display = set;

            # Actions to switch layouts.
            # Note: if you uncomment these, make sure you do NOT have
            # a matching layout switch hotkey configured in xkb options above.
            # Having both at once on the same hotkey will break the switching,
            # since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
            # Mod+Space       { switch-layout = "next"; }
            # Mod+Shift+Space { switch-layout = "prev"; }

            "Print".screenshot = set;
            "Ctrl+Print".screenshot-screen = set;
            "Alt+Print".screenshot-window = set;
            "Shift+Print" = _: {
              content.spawn = "ocr";
              props.repeat = false;
            };

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

            # The quit action will show a confirmation dialog to avoid accidental exits.
            "Ctrl+Alt+Delete".quit = set;

            # Powers off the monitors. To turn them back on, do any input like
            # moving the mouse or pressing any other key.
            "Mod+Shift+P".power-off-monitors = set;
          };
      };
    };
}
