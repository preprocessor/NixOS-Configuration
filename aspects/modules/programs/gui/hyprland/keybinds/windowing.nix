{
  exo.mods.desktop = {
    my.hyprland.lua.files = {
      "keybinds.windowing.base".content = /* lua */ ''
        -- ░█░█░▀█▀░█▀█░█▀▄░█▀█░█░█░▀█▀░█▀█░█▀▀
        -- ░█▄█░░█░░█░█░█░█░█░█░█▄█░░█░░█░█░█░█
        -- ░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀

        -- Focus windows or workspaces with j/k
        -- Focus windows or  monitors  with h/l
        -- + CTRL = Move window
        -- Same maps for MOD + scroll
        for dir, key in pairs({
          ["left"] = "h",
          ["down"] = "j",
          ["up"] = "k",
          ["right"] = "l"
        }) do
          hl.bind("SUPER + " .. key, utils.focus(key))
          hl.bind("SUPER + CTRL + " .. key, utils.move(key))
        end

        -- Switch workspaces with SUPER + [0-9]
        -- Move active window to a workspace with SUPER + CTRL + [0-9]
        -- Special workspaces with F1-10
        for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
          hl.bind("SUPER + KP_" .. key, hl.dsp.workspace.toggle_special(i))
          hl.bind("SUPER + CTRL + KP_" .. key, hl.dsp.window.move({ workspace = "special:" .. i }))
        end

        -- Named special workspaces
        for key, name in pairs({
          ["X"] = "scratch",
          ["S"] = "steam",
          ["A"] = "rice",
          ["D"] = "dashboard"
        }) do
          hl.bind("SUPER + " .. key, hl.dsp.workspace.toggle_special(name))
          hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ workspace = "special:" .. name }))
        end
      '';

      "keybinds.windowing.management".content = /* lua */ ''
        -- Consume/Expel
        hl.bind("SUPER + bracketright", hl.dsp.layout("consume_or_expel next"))
        hl.bind("SUPER + bracketleft", hl.dsp.layout("consume_or_expel prev"))

        -- Move/resize windows with mainMod + LMB/RMB and dragging
        hl.bind("SUPER + mouse:272", function()
          local win = hl.get_active_window()
          if not win then return end
          if not win.floating then return end
          hl.dispatch(hl.dsp.window.drag())
        end, { mouse = true })

        hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

        hl.bind("SUPER + P", hl.dsp.window.pin({ action = "toggle" }))

        hl.bind("SUPER + F", hl.dsp.window.fullscreen_state({ internal = 2, client = 2, action = "toggle", layout_aware = false }))

        hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "toggle", layout_aware = false }))

        hl.bind("SUPER + R", hl.dsp.layout("colresize +conf"))

        hl.bind("SUPER + SHIFT + R", hl.dsp.layout("colresize -conf"))

        hl.bind("SUPER + C", function()
          local prev = hl.get_config("scrolling.focus_fit_method")

          hl.config({ scrolling = { focus_fit_method = 0 } })
          hl.dispatch(hl.dsp.layout("center"))
          hl.config({ scrolling = { focus_fit_method = prev } })
        end)

        hl.bind("ALT + TAB", function()
          local window = hl.get_active_window()
          if not window then return end

          if window.floating then
              hl.dispatch(hl.dsp.window.cycle_next({ next = true, tiled = true, floating = false }))
          else
              hl.dispatch(hl.dsp.window.cycle_next({ next = true, tiled = false, floating = true }))
          end
        end, {release = true})
      '';
    };
  };
}
