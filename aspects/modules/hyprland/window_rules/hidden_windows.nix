{
  w.desktop = {
    custom.programs.hyprland.lua.files = {
      "keybinds.hide_windows".content = /* lua */ ''
        hl.bind("SUPER + B", function()
          local win = hl.get_active_window()
          if not win then return end
          hl.dispatch(hl.dsp.window.tag({ tag = "hidden", window = win }))
        end)
      '';

      "window_rules.hide_windows".content = /* lua */ ''
        local hide_rule = hl.window_rule({
          name = "hide windows",
          match = {
            tag = "hidden"
          },
          no_screen_share = true,
          border_color = "rgb(ff0d2d)",
        })

        hl.on("screenshare.state", function(active, type, name)
          -- local state = nil
          -- if active == "started" or active == true then
          --   state = true
          -- elseif active == "stopped" or active == false then
          --   state = false
          -- end
          -- if not state then return end
          --
          -- local header = state and "Screenshare: Active" or "Screenshare: Ended"
          --
          -- -- type 0 monitor
          -- -- type 1 window
          -- -- type 2 region
          -- local types = { "Monitor", "Window", "Region" }
          -- local kind = "Type: " .. types[type + 1] -- plus 1 because lua indexes start at 1 not 0
          --
          -- local display = "Display: " .. name
          --
          -- hl.notification.create({
          --   text = header .. "\n" .. kind .. "\n" .. display,
          --   timeout = 5000,
          -- })
          --
          hide_rule:set_enabled(active)
        end)

        hl.window_rule({
          name = "hide logins",
          match = {
            title = "(login|signin|log in|sign in|mail)"
          },
          tag = "+hidden"
        })
      '';
    };
  };
}
