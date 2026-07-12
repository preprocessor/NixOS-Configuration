{
  w.desktop = {
    my.hyprland.lua.files = {
      # https://github.com/Yujonpradhananga/moon/blob/0776b45ca3a22e3ef85b54c131bcf52ceec840a1/hypr/orbit.lua
      "layouts.orbit".content = /* lua */ ''
        hl.layout.register("orbit", {
        	recalculate = function(ctx)
        		local n = #ctx.targets
        		if n == 0 then
        			return
        		end

        		local cx = ctx.area.x + ctx.area.w / 2
        		local cy = ctx.area.y + ctx.area.h / 2

        		if n == 1 then
        			local size = math.min(ctx.area.w, ctx.area.h) * 0.72
        			ctx.targets[1]:place({ x = cx - size / 2, y = cy - size / 2, w = size, h = size })
        			return
        		end

        		local tile_size = math.min(ctx.area.w, ctx.area.h) * 0.30
        		local radius = math.min(ctx.area.w, ctx.area.h) / 2 - tile_size / 2 - 16
        		local angle_step = (2 * math.pi) / n

        		for i, target in ipairs(ctx.targets) do
        			local angle = -math.pi / 2 + (i - 1) * angle_step
        			local tx = cx + radius * math.cos(angle)
        			local ty = cy + radius * math.sin(angle)
        			target:place({ x = tx - tile_size / 2, y = ty - tile_size / 2, w = tile_size, h = tile_size })
        		end
        	end,
        })
      '';
    };
  };
}
