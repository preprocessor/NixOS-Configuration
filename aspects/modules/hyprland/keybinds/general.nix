{
  exo.mods.desktop =
    { pkgs, lib, ... }:

    let
      powercontrols = pkgs.writeShellScript "powercontrols" ''
        CHOICE=$(gum choose --cursor=" " --cursor.foreground="#fff" --header="" --no-show-help 'Log Out' 'Reboot' 'Power Off')

        if [[ -z $CHOICE ]]; then
          exit 0
        fi

        gum confirm --no-show-help --selected.background="#EC7420" --prompt.foreground="#EC7420" "$CHOICE?" || exit 0

        case $CHOICE in
          "Log Out")
            command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop
            ;;
          "Reboot")
            hyprshutdown -t "Restarting..." --post-cmd "reboot"
            ;;
          "Power Off")
            hyprshutdown -t "Shutting down..." --post-cmd "shutdown -P 0"
            ;;
        esac
      '';
    in
    {
      my.hyprland.lua.files = {
        "keybinds.base".content = /* lua */ ''
          -- Close
          hl.bind("SUPER + Q", hl.dsp.window.close())
          -- Float
          hl.bind("SUPER + Backslash", function () utils.float_center() end)
        '';

        "keybinds.screenshot".content = /* lua */ ''
          -- Screenshots
          hl.bind("Print", hl.dsp.exec_cmd('wayfreeze & PID=$!; sleep .1; grim -g "$(slurp)" - | wl-copy; kill $PID'))
          hl.bind("CTRL + Print", hl.dsp.exec_cmd('grim - | wl-copy'))
          hl.bind("SUPER + Print", hl.dsp.exec_cmd('wayfreeze & PID=$!; sleep .1; grim -g "$(slurp -o -r -c \'##ff0000ff\')" -t ppm - | ${lib.getExe pkgs.satty} --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date \'+%Y%m%d-%H:%M:%S\').png; kill $PID'))
          hl.bind("SUPER + CTRL + Print", hl.dsp.exec_cmd('grim  -t ppm - | ${lib.getExe pkgs.satty} --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date \'+%Y%m%d-%H:%M:%S\').png'))
        '';

        "keybinds.powercontrols".content = /* lua */ ''
          -- Power Controls
          hl.bind("CTRL + ALT + Delete", function()
            utils.toggle_window("powercontrols", "kitty --class powercontrols -e ${powercontrols}", {
              border_size  = 2,
              pin = true,
              float = true,
              center = true,
              stay_focused = true,
              size = { 260, 110 },
            })
          end)
        '';

        "keybinds.zoom".content = /* lua */ ''
          local MAX_ZOOM = 5
          local MIN_ZOOM = 1
          local ZOOM_TOGGLE_FACTOR = 5

          ---@param offset number
          ---@return nil
          local function zoom(offset)
            local current = hl.get_config("cursor.zoom_factor")
            if offset ~= nil then
              current = current + offset
            elseif current ~= MIN_ZOOM then
              current = MIN_ZOOM
            else
              current = ZOOM_TOGGLE_FACTOR
            end
            current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
            hl.config({ cursor = { zoom_factor = current } })
          end

          hl.bind("SUPER + Z", zoom)
          hl.bind("SUPER + KP_Add", function()
            zoom(0.5)
          end)
          hl.bind("SUPER + KP_Subtract", function()
            zoom(-0.5)
          end)

          -- ░█▄█░█▀▀░█▀▄░▀█▀░█▀█
          -- ░█░█░█▀▀░█░█░░█░░█▀█
          -- ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀░▀

          -- multimedia keys for volume
          hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
            { locked = true, repeating = true })
          hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
            { locked = true, repeating = true })
          hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
            { locked = true, repeating = true })
          hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
            { locked = true, repeating = true })

          -- multimedia keys for playback control
          hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
          hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
          hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
          hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
        '';
      };
    };
}
