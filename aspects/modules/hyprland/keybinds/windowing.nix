{
  w.desktop = {
    wrappers.hyprland.lua.files = {
      "keybinds".content = /* lua */ ''
        -- ░█░█░▀█▀░█▀█░█▀▄░█▀█░█░█░▀█▀░█▀█░█▀▀
        -- ░█▄█░░█░░█░█░█░█░█░█░█▄█░░█░░█░█░█░█
        -- ░▀░▀░▀▀▀░▀░▀░▀▀░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀

        -- Focus windows or workspaces with j/k
        -- Focus windows or  monitors  with h/l
        -- + CTRL = Move window
        -- Same maps for MOD + scroll
        for dir, key in pairs({
          ["left"] = "h",
          ["up"] = "j",
          ["down"] = "k", -- i know j/k are reversed but for mouse motions this makes the most sense
          ["right"] = "l"
        }) do
          hl.bind("SUPER + " .. key, utils.focus(key))
          hl.bind("SUPER + CTRL + " .. key, utils.move(key))
          hl.bind("SUPER + mouse_" .. dir, utils.focus(key))
          hl.bind("SUPER + CTRL + mouse_" .. dir, utils.move(key))
        end

        -- Switch workspaces with SUPER + [0-9]
        -- Move active window to a workspace with SUPER + CTRL + [0-9]
        for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        -- Scratch pad
        hl.bind("SUPER + X", hl.dsp.workspace.toggle_special("scratch"))
        hl.bind("SUPER + CTRL + X", hl.dsp.window.move({ workspace = "special:scratch" }))

        -- Move/resize windows with mainMod + LMB/RMB and dragging
        hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

        -- switch/cycle layouts
        hl.bind("SUPER + N", function()
          local workspace   = hl.get_active_workspace()
          if not workspace then return end

          -- local layouts     = { "scrolling", "dwindle" }
          local layouts = {
            ["lua:grid"] = "scrolling",
            ["scrolling"] = "dwindle",
            ["dwindle"] = "lua:grid",
          }

          local next_layout = layouts[workspace.tiled_layout]
          if not next_layout then return end

          hl.workspace_rule({ workspace = "name:" .. workspace.name, layout = next_layout })

          if next_layout == "scrolling" then
            local prev = hl.get_config("scrolling.focus_fit_method")
            hl.config({ scrolling = { focus_fit_method = 0 } })
            hl.timer(function()
              hl.config({ scrolling = { focus_fit_method = prev } })
            end, { timeout = 50, type = "oneshot" })
          end
        end)

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
          utils.layout_exec({
            ["scrolling"] = function()
              hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }))
            end,
            ["dwindle"] = function()
              hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 1, client = 3, action = "toggle" }))
            end
          })
        end)

        hl.bind("SUPER + SHIFT + F", function()
          utils.layout_exec({
            ["scrolling"] = function()
              hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 2, client = 3, action = "toggle" }))
            end,
            ["dwindle"] = function()
              hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 3, client = 3, action = "toggle" }))
            end
          })
        end)

        hl.bind("SUPER + R", function()
          utils.layout_exec({
            ["scrolling"] = function()
              hl.dispatch(hl.dsp.layout("colresize +conf"))
            end,

            ["dwindle"] = function()
              hl.dispatch(hl.dsp.layout("splitratio +0.25"))
            end
          })
        end)

        hl.bind("SUPER + SHIFT + R", function()
          utils.layout_exec({
            ["scrolling"] = function()
              hl.dispatch(hl.dsp.layout("colresize -conf"))
            end,

            ["dwindle"] = function()
              hl.dispatch(hl.dsp.layout("splitratio -0.25"))
            end
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
            end
          })
        end)
      '';
    };
  };
}
