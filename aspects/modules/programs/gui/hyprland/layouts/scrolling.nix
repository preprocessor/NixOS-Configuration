{
  exo.mods.desktop = {
    my.hyprland.lua.files."layouts.scrolling".content = /* lua */ ''
      hl.config({
      	general = {
      		layout = "scrolling",
      	},

      	layout = {
      		single_window_aspect_ratio = { 16, 9 },
      	},

      	scrolling = {
      		fullscreen_on_one_column = false,
      		explicit_column_widths = "0.25, 0.33333, 0.5, 0.66667, 0.75",
      		wrap_focus = false,
      		wrap_swapcol = false,
      	},
      })

      local rebuild_state = function(ws)
      	if ws.tiled_layout ~= "scrolling" then
      		return
      	end

      	local windows = utils.get_tiled_windows(ws)
      	local count = #windows

      	if count == 1 then
      		hl.dispatch(hl.dsp.layout("colresize 0.7296"))
      	elseif count == 2 or count == 3 then
      		hl.dispatch(hl.dsp.layout("fit all"))
      	elseif count > 3 then
      		for _, w in ipairs(windows) do
      			hl.dispatch(hl.dsp.focus({ window = w }))
      			hl.dispatch(hl.dsp.layout("colresize 0.33333"))
      		end
      	end
      end

      hl.on("window.open", function(_win)
      	local ws = hl.get_active_workspace()
      	if not ws then return end
      	rebuild_state(ws)
      end)

      -- when closing windows resize them and make them fit the screen, single window is always 16:9
      hl.on("window.destroy", function()
      	local ws = hl.get_active_workspace()
      	if not ws then return end
      	rebuild_state(ws)
      end)

      hl.on("window.move_to_workspace", function(_win, ws)
      	if not ws then return end
      	rebuild_state(ws)
      end)

      hl.on("workspace.active", function(ws)
      	if not ws then return end
      	rebuild_state(ws)
      end)

      hl.on("config.reloaded", function()
      	local ws = hl.get_active_workspace()
      	if not ws then return end
      	rebuild_state(ws)
      end)
    '';
  };
}
