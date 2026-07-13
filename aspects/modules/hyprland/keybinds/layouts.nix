{
  exo.mods.desktop = {
    my.hyprland.lua.files = {
      "keybinds.overview".content = /* lua */ ''
        local overview = {
          origin_window = nil,
          origin_layout = nil
        }

        overview.open = function()
          local workspace = hl.get_active_workspace()
          if not workspace then return end

          overview.origin_window = hl.get_active_window()
          overview.origin_layout = workspace.tiled_layout

          hl.workspace_rule({ workspace = "name:" .. workspace.name, layout = "lua:grid" })
          hl.dispatch(hl.dsp.submap("overview"))
        end

        overview.exit = function(select)
          local workspace = hl.get_active_workspace()
          if not workspace then return end

          local restore_layout = overview.origin_layout or "scrolling"

          hl.workspace_rule({ workspace = "name:" .. workspace.name, layout = restore_layout })
          hl.dispatch(hl.dsp.submap("reset"))

          if not select then
            -- Escape key restore original window focus first
            if overview.origin_window then
              hl.dispatch(hl.dsp.focus({ window = overview.origin_window }))
            end
          end

          -- center in scrolling
          if restore_layout == "scrolling" then
            local prev = hl.get_config("scrolling.focus_fit_method")
            hl.config({ scrolling = { focus_fit_method = 0 } })
            hl.timer(function()
              hl.config({ scrolling = { focus_fit_method = prev } })
            end, { timeout = 50, type = "oneshot" })
          end

          overview.origin_window = nil
          overview.origin_layout = nil
        end

        hl.define_submap("overview", function()
          hl.bind("h", hl.dsp.focus({ direction = "left" }), { repeating = true })
          hl.bind("l", hl.dsp.focus({ direction = "right" }), { repeating = true })
          hl.bind("k", hl.dsp.focus({ direction = "up" }), { repeating = true })
          hl.bind("j", hl.dsp.focus({ direction = "down" }), { repeating = true })
          hl.bind("return", function() overview.exit(true) end)
          hl.bind("escape", function() overview.exit(false) end)
        end)

        hl.bind("SUPER + TAB", function() overview.open() end)

        -- switch/cycle layouts
        hl.bind("SUPER + N", function()
          utils.layout_cycle( {
            ["dwindle"] = "lua:centercol",
            ["lua:centercol"] = "scrolling",
            ["scrolling"] = "dwindle",
          })
        end)

        hl.bind("SUPER + SHIFT + N", function()
          utils.layout_cycle( {
            ["lua:centercol"] = "dwindle",
            ["scrolling"] = "lua:centercol",
            ["dwindle"] = "scrolling",
          })
        end)
      '';
    };
  };
}
