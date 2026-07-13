{
  exo.mods.desktop = {
    my.hyprland.lua.pre = ''utils = require("files.utils")'';

    my.hyprland.lua.files."utils" = {
      autoLoad = false;
      content = /* lua */ ''
        local utils = {}

        local dir_table = {
          h = "left",
          j = "down",
          k = "up",
          l = "right",
        }
        local function wrap_dsp(...)
          local dsps = { ... }
          return function()
            for _, dsp in ipairs(dsps) do
              local result = hl.dispatch(dsp)
              if result.ok then
                return result.ok
              end
            end
            return false
          end
        end

        local dist = {
          h = function(win2, win1)
            local x1, y1, w1, h1 = win1.at.x, win1.at.y, win1.size.x, win1.size.y
            if not win2 then return -x1 - w1 end
            local x2, y2, w2, h2 = win2.at.x, win2.at.y, win2.size.x, win2.size.y
            return y1 + h1 > y2 and y1 < y2 + h2 and x1 + w1 < x2 and x2 - x1 - w1
          end,
          l = function(win2, win1)
            local x1, y1, w1, h1 = win1.at.x, win1.at.y, win1.size.x, win1.size.y
            if not win2 then return x1 end
            local x2, y2, w2, h2 = win2.at.x, win2.at.y, win2.size.x, win2.size.y
            return y2 + h2 > y1 and y2 < y1 + h1 and x2 + w2 < x1 and x1 - x2 - w2
          end,
          k = function(win2, win1)
            local x1, y1, w1, h1 = win1.at.x, win1.at.y, win1.size.x, win1.size.y
            if not win2 then return -y1 - h1 end
            local x2, y2, w2, h2 = win2.at.x, win2.at.y, win2.size.x, win2.size.y
            return x1 + w1 > x2 and x1 < x2 + w2 and y1 + h1 < y2 and y2 - y1 - h1
          end,
          j = function(win2, win1)
            local x1, y1, w1, h1 = win1.at.x, win1.at.y, win1.size.x, win1.size.y
            if not win2 then return y1 end
            local x2, y2, w2, h2 = win2.at.x, win2.at.y, win2.size.x, win2.size.y
            return x2 + w2 > x1 and x2 < x1 + w1 and y2 + h2 < y1 and y1 - y2 - h2
          end,
        }

        local function find_best_window(dir, win, allwin)
          local best = 99999
          local ret = nil
          for _, wwin in ipairs(allwin) do
            if wwin ~= win then
              local dis = dist[dir](win, wwin)
              if dis then
                if dis < best then
                  best = dis
                  ret = wwin
                elseif dis == best and wwin.focus_history_id < ret.focus_history_id then
                  ret = wwin
                end
              end
            end
          end
          return ret
        end

        utils.focus_window = function(dir)
          return function()
            local win = hl.get_active_window()
            if not win then return false end
            local space = hl.get_active_special_workspace() or hl.get_active_workspace()
            if not space then return false end
            if not space then return false end

            if win.floating and space.windows > 1 then
              if dir == "h" or dir == "l" then
              hl.dispatch(hl.dsp.focus({direction = dir_table[dir] }))
              return hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top", win = win }))

              else return false end
            end

            if space.tiled_layout == "monocle" then
              if dir == "h" then
                return hl.dispatch(hl.dsp.layout("cycleprev"))
              elseif dir == "l" then
                return hl.dispatch(hl.dsp.layout("cyclenext"))
              end
            end

            local allwin = hl.get_workspace_windows(space)
            local ret = find_best_window(dir, win, allwin)
            if ret then
              return hl.dispatch(hl.dsp.focus({ window = ret }))
            end

            return false
          end
        end

        -- vertical stack: j = id+1, k = id-1
        local function adj_workspace(dir, space)
          if dir == "j" then
            if space.is_empty and not space.is_persistent then
              return "e+1"
            else
              return space.id + 1
            end
          elseif dir == "k" then
            return "-1"
          end
          return nil
        end

        utils.focus_space = function(dir)
          return function()
            local space = hl.get_active_workspace()
            if not space then return false end
            local target = adj_workspace(dir, space)
            if not target then return false end
            local result = hl.dispatch(hl.dsp.focus({ workspace = target, on_current_monitor = true }))
            return result and result.ok
          end
        end

        -- vertical (j/k): window → workspace
        -- horizontal (h/l): window → monitor
        utils.focus = function(dir)
          local fw = utils.focus_window(dir)
          if dir == "j" or dir == "k" then
            return function()
              local fs = utils.focus_space(dir)
              return fw() or fs()
            end
          else
            return function()
              local fm = hl.dispatch(hl.dsp.focus({ monitor = dir_table[dir] }))
              return fw() or fm
            end
          end
        end

        local function move_win_to_adj_space(dir)
          return function()
            local space = hl.get_active_workspace()
            if not space then return false end
            local target = adj_workspace(dir, space)
            if not target then return false end
            return wrap_dsp(hl.dsp.window.move({ workspace = target, follow = true }))()
          end
        end

        local function move_win_to_monitor(dir)
          if #hl.get_monitors() <= 1 then
            return function() end
          end
          return wrap_dsp(hl.dsp.window.move({ monitor = dir_table[dir], follow = true }))
        end

        -- vertical (j/k): swap with window → else move to adj workspace
        -- horizontal (h/l): swap with window → else move to adj monitor
        utils.move = function(dir)
          if dir == "j" or dir == "k" then
            local ms = move_win_to_adj_space(dir)
            return function()
              local win = hl.get_active_window()
              if win then
                local space = hl.get_active_workspace()
                local allwin = hl.get_workspace_windows(space)
                if find_best_window(dir, win, allwin) then
                  return wrap_dsp(hl.dsp.window.swap({ direction = dir_table[dir] }))()
                end
              end
              return ms()
            end
          else
            local mm = move_win_to_monitor(dir)
            return function()
              local win = hl.get_active_window()
              if win then
                local space = hl.get_active_workspace()
                if not space then return end
                local allwin = hl.get_workspace_windows(space)
                if find_best_window(dir, win, allwin) then
                  return wrap_dsp(hl.dsp.window.swap({ direction = dir_table[dir] }))()
                end
              end
              return mm()
            end
          end
        end

        utils.toggle_window = function(class, exec, props)
          local win = hl.get_window("class:" .. class)

          if win then
            hl.dispatch(hl.dsp.window.close({ window = win }))
          else
            hl.dispatch(hl.dsp.exec_cmd(exec, props))
          end
        end

        utils.float_center = function ()
          local win = hl.get_active_window()
          if not win then return end

          if win.floating then
            hl.dispatch(hl.dsp.window.float({ action = "unset" }))
          else
            hl.dispatch(hl.dsp.window.float({ action = "set" }))
            hl.dispatch(hl.dsp.window.resize({ x = 2100, y = 1200, relative = false }))
            hl.dispatch(hl.dsp.window.center())
          end
        end

        utils.layout_exec = function(case)
          local space = hl.get_active_special_workspace() or hl.get_active_workspace()
          if not space then return false end

          local fn = case[space.tiled_layout]
          if not fn then return false end
          fn()
        end

        utils.layout_cycle = function(layout_map)
          local workspace   = hl.get_active_workspace()
          if not workspace then return end

          local next_layout = layout_map[workspace.tiled_layout] or "lua:centercol"

          hl.workspace_rule({ workspace = "name:" .. workspace.name, layout = next_layout })

          if next_layout == "scrolling" then
            local prev = hl.get_config("scrolling.focus_fit_method")
            hl.config({ scrolling = { focus_fit_method = 0 } })
            hl.timer(function()
              hl.config({ scrolling = { focus_fit_method = prev } })
            end, { timeout = 50, type = "oneshot" })
          end
        end

        utils.does_file_exist = function(path)
          local f = io.open(path, "r")
          if f ~= nil then
              io.close(f)
              return true
          else
              return false
          end
        end

        utils.clamp = function(x, min, max)
            return math.max(min, math.min(max, x))
        end

        return utils
      '';
    };
  };
}
