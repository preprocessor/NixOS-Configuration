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
          hl.bind("SUPER + mouse_" .. dir, utils.focus(key), { non_consuming = false })
          hl.bind("SUPER + CTRL + mouse_" .. dir, utils.move(key), { non_consuming = false })
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

        hl.bind("CTRL + Space", hl.dsp.submap("layout"))

        -- Start a submap called "resize".
        hl.define_submap("layout", function()
          -- Set repeating binds for moving the active window.
          hl.bind("h", hl.dsp.window.move({ x = -50, y = 0, relative = true }), { repeating = true })
          hl.bind("k", hl.dsp.window.move({ x = 0, y = -50, relative = true }), { repeating = true })
          hl.bind("j", hl.dsp.window.move({ x = 0, y = 50, relative = true }), { repeating = true })
          hl.bind("l", hl.dsp.window.move({ x = 50, y = 0, relative = true }), { repeating = true })
          -- Set repeating binds for resizing the active window.
          hl.bind("SHIFT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
          hl.bind("SHIFT + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
          hl.bind("SHIFT + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
          hl.bind("SHIFT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })

          hl.bind("f", function () utils.float_center() end)

          -- Use `reset` to go back to the global submap
          hl.bind("escape", hl.dsp.submap("reset"))
        end)

        hl.bind("SUPER + F", function()
          hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }))
        end)

        hl.bind("SUPER + SHIFT + F", function()
          hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 2, client = 3, action = "toggle" }))
        end)

        hl.bind("SUPER + R", function()
          utils.layout_exec({
            ["scrolling"] = function()
              hl.dispatch(hl.dsp.layout("colresize +conf"))
            end,

            ["dwindle"] = function()
              hl.dispatch(hl.dsp.layout("splitratio +0.25"))
            end,

            ["lua:centercol"] = function()
              hl.dispatch(hl.dsp.layout("resize"))
            end,
          })
        end)

        hl.bind("SUPER + SHIFT + R", function()
          utils.layout_exec({
            ["scrolling"] = function()
              hl.dispatch(hl.dsp.layout("colresize -conf"))
            end,

            ["dwindle"] = function()
              hl.dispatch(hl.dsp.layout("splitratio -0.25"))
            end,

            ["lua:centercol"] = function()
              hl.dispatch(hl.dsp.layout("resize"))
            end,
          })
        end)

        hl.bind("SUPER + C", function()
          utils.layout_exec({
            ["scrolling"] = function()
              local prev = hl.get_config("scrolling.focus_fit_method")

              hl.config({ scrolling = { focus_fit_method = 0 } })
              hl.dispatch(hl.dsp.layout("center"))
              hl.config({ scrolling = { focus_fit_method = prev } })
            end,

            ["dwindle"] = function()
              hl.dispatch(hl.dsp.layout("togglesplit"))
            end,

            ["lua:centercol"] = function()
              hl.dispatch(hl.dsp.layout("swap"))
            end,
          })
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
