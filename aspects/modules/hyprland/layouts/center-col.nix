{
  w.desktop = {
    custom.programs.hyprland.lua.files."layouts.center_col".content = /* lua */ ''
      local M = {
        ratio = 0.5,
        swap = false,
      }

      M.layout_msg = function(ctx, msg)
        local command, arg = msg:match("^(%S+)%s*(.*)$")

        if command == "ratio" then
          local arg1 = arg:sub(1, 1)
          if arg1 == "+" or arg1 == "-" then
            M.ratio = utils.clamp(M.ratio + tonumber(arg), 0.2, 0.8)
          else
            M.ratio = utils.clamp(tonumber(arg), 0.2, 0.8)
          end
        elseif command == "swap" then
          M.swap = not M.swap
        else
          return "centercol: expected ratio [+-]<0.01..0.9> or swap"
        end

        return true
      end

      M.recalculate = function(ctx)
        local n = #ctx.targets
        if n == 0 then
          return
        end

        local area = ctx.area

        local centerWidth = area.w * M.ratio
        local sideWidth = math.floor((area.w - centerWidth) * 0.5)

        -- single window
        if n == 1 then
          ctx.targets[1]:place({
            x = area.x + sideWidth,
            y = area.y,
            w = centerWidth,
            h = area.h,
          })
          return
        end

        -- two window
        if n == 2 then
          ctx.targets[1]:place({
            x = area.x,
            y = area.y,
            w = centerWidth,
            h = area.h,
          })
          ctx.targets[2]:place({
            x = area.x + centerWidth,
            y = area.y,
            w = area.w - centerWidth,
            h = area.h,
          })
          return
        end

        local left = {}
        local right = {}

        -- split side windows
        for i = 2, n do
          if i % 2 == 0 then
            table.insert(left, ctx.targets[i])
          else
            table.insert(right, ctx.targets[i])
          end
        end

        -- center/main
        ctx.targets[1]:place({
          x = area.x + sideWidth,
          y = area.y,
          w = centerWidth,
          h = area.h,
        })

        for i, side in pairs({ left, right }) do
          local sideCount = #side

          if sideCount > 0 then
            local h = math.floor(area.h / sideCount)
            local left_idx = M.swap and 1 or 2
            local x = i == left_idx and area.x or area.x + sideWidth + centerWidth

            local sidePlace = function(target, y)
              target:place({
                x = x,
                y = y,
                w = sideWidth,
                h = h,
              })
            end

            for j, target in ipairs(side) do
              sidePlace(target, area.y + ((j - 1) * h))
            end
          end
        end
      end

      hl.layout.register("centercol", {
        layout_msg = M.layout_msg,
        recalculate = M.recalculate,
      })
    '';
  };
}
