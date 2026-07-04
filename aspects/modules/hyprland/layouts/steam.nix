{
  w.desktop = {
    custom.programs.hyprland.lua.files = {
      "layouts.steam".content = /* lua */ ''
        hl.layout.register("steam", {
          recalculate = function(ctx)
            local targets = ctx.targets
            local n = #targets
            if n == 0 then
              return
            end
            local area = ctx.area

            local sideWidth = area.w * 0.3333 * 0.5

            local side = {}

            for _, target in ipairs(targets) do
              local w = target.window
              if not w then
                return
              end
              if w.class == "steam" then
                local title = w.title or ""
                if title == "Steam" then
                  target:place({
                    x = area.x + sideWidth,
                    y = area.y,
                    w = area.w * 0.6666,
                    h = area.h,
                  })
                elseif title:find("Friends List", 1, true) then
                  target:place({
                    x = area.x + area.w * 0.85,
                    y = area.y + area.h * 0.1,
                    w = area.w * 0.10,
                    h = area.h * 0.8,
                  })
                else
                  table.insert(side, target)
                end
              end
            end

            local sideCount = #side

            if sideCount > 0 then
              local h = math.floor(area.h / sideCount)

              local sidePlace = function(target, y)
                target:place({
                  x = area.x,
                  y = y,
                  w = sideWidth,
                  h = h,
                })
              end

              for j, target in ipairs(side) do
                sidePlace(target, area.y + ((j - 1) * h))
              end
            end
          end,
        })
      '';
    };
  };
}
