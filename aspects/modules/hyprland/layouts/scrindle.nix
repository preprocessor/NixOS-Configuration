{
  exo.mods.desktop = {
    my.hyprland.lua.files."layouts.scrindle".content = /* lua */ ''
      local sort_windows_ltr = function(windows)
        table.sort(windows, function(a, b)
          return a.at.x < b.at.x
        end)
        return windows
      end

      local find_rightmost_window = function(windows)
        local x = 0
        local right_win = nil
        for _, win in pairs(windows) do
          local right_side_x = win.at.x + win.size.x
          if right_side_x > x then
            x = right_side_x
            right_win = win
          end
        end
        return right_win
      end

      -- scroll behaves like dwindle for first 4 windows
      hl.on("window.open_early", function(w)
        if w.floating then
          return
        end
        local ws = w.workspace
        if not ws then
          return
        end
        if ws.tiled_layout ~= "scrolling" then
          return
        end

        local windows = utils.get_tiled_windows(ws)
        local count = #windows
        local rightmost_window = find_rightmost_window(windows)

        -- count here is the count BEFORE the new window is added
        if count % 4 == 0 then
          if rightmost_window then
            hl.dispatch(hl.dsp.focus({ window = rightmost_window }))
          end
          hl.dispatch(hl.dsp.layout("inhibit_scroll 1"))
        end
      end)

      hl.on("window.open", function(w)
        if w.floating then
          return
        end
        local ws = w.workspace
        if not ws then
          return
        end
        if ws.tiled_layout ~= "scrolling" then
          return
        end

        local count = utils.count_tiled_windows(ws)

        if count == 1 then
          hl.dispatch(hl.dsp.layout("colresize 0.7296"))
        elseif count == 2 or count == 3 then
          hl.dispatch(hl.dsp.layout("fit all"))
        elseif count % 4 == 0 then
          -- Explicitly focus the new window first
          hl.dispatch(hl.dsp.focus({ window = w }))
          hl.dispatch(hl.dsp.layout("focus l"))
          hl.dispatch(hl.dsp.layout("consume"))
          hl.dispatch(hl.dsp.layout("focus d"))
        end
        hl.dispatch(hl.dsp.layout("inhibit_scroll 0"))
      end)

      hl.on("workspace.active", function(ws)
        if ws.tiled_layout ~= "scrolling" then
          return
        end

        local windows = sort_windows_ltr(utils.get_tiled_windows(ws))
        local count = #windows

        if count == 1 then
          hl.dispatch(hl.dsp.layout("colresize 0.7296"))
        elseif count == 2 or count == 3 then
          hl.dispatch(hl.dsp.layout("fit all"))
        elseif count > 3 then
          for i, w in pairs(windows) do
            hl.dispatch(hl.dsp.focus({ window = w }))
            hl.dispatch(hl.dsp.layout("colresize 0.33333"))
            if i % 4 == 0 then
              local prev_win = windows[i - 1]
              if prev_win.at.x ~= w.at.x then
                hl.dispatch(hl.dsp.focus({ window = w }))
                hl.dispatch(hl.dsp.layout("focus l"))
                hl.dispatch(hl.dsp.layout("consume"))
                hl.dispatch(hl.dsp.layout("focus d"))
              end
            end
          end
        end
      end)

      -- when closing windows resize them and make them fit the screen, single window is always column width 0.71
      hl.on("window.destroy", function()
        local ws = hl.get_active_workspace()
        if not ws then
          return
        end
        if ws.tiled_layout ~= "scrolling" then
          return
        end

        local count = utils.count_tiled_windows(ws)
        if count == 1 then
          hl.dispatch(hl.dsp.layout("colresize 0.7296"))
        elseif count == 2 or count == 3 then
          hl.dispatch(hl.dsp.layout("fit all"))
        end
      end)

    '';
  };
}
