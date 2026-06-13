{
  w.desktop = {
    wrappers.hyprland.lua.files = {
      "keybinds".content = /* lua */ ''

        -- ░█▀▀░█▀▀░█▀█░█▀▀░█▀▄░█▀█░█░░
        -- ░█░█░█▀▀░█░█░█▀▀░█▀▄░█▀█░█░░
        -- ░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀▀

        -- Close
        hl.bind("SUPER + Q", hl.dsp.window.close())
        -- Exit
        hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || uwsm stop"))
        -- Float
        hl.bind("SUPER + Backslash", function () utils.float_center() end)
        -- Print keybinds
        hl.bind("Print", hl.dsp.exec_cmd("slurp | grim -g - - | wl-copy"))

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
