{
  w.default =
    { pkgs, ... }:
    {
      wrappers.niri.settings = {
        spawn-at-startup = [ "swayosd-server" ];

        binds = {
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
        };
      };
    };
}
