{
  w.desktop = {
    wrappers.hyprland.lua.files = {
      "workspaces".content = /* lua */ ''
        for index, name in ipairs({ "web", "dev", "chat", "media", "games" }) do
          hl.workspace_rule({ workspace = tostring(index), default_name = name, persistent = true })
        end

        hl.workspace_rule({ workspace = "name:web", layout = "scrolling" })
        hl.workspace_rule({ workspace = "name:games", layout = "monocle" })
        hl.window_rule({
          name   = "floating-media-workspace",
          match  = { workspace = "name:media" },

          size   = "1200 1200",
          center = true,
          float  = true,
        })

        hl.workspace_rule({
          workspace = "special:scratch",
          gaps_out = 100,
          border_size = 5,
          on_created_empty =
          "kitty -o background_opacity=0.8"
        })

        hl.on("window.open", function(w)
          local ws = w.workspace
          if not ws then return end
          if ws.name ~= "dev" then return end
          if ws.tiled_layout ~= "scrolling" then return end

          local count = ws.windows
          if count >= 2 and count <= 3 then
            hl.dispatch(hl.dsp.layout("fit all"))
          elseif count == 4 then
            hl.dispatch(hl.dsp.layout("inhibit_scroll 1"))
            hl.dispatch(hl.dsp.layout("focus l"))
            hl.dispatch(hl.dsp.layout("consume"))
            hl.dispatch(hl.dsp.layout("focus d"))
            hl.dispatch(hl.dsp.layout("inhibit_scroll 0"))
            hl.dispatch(hl.dsp.layout("fit all"))
          end
        end)
      '';
    };
  };
}
