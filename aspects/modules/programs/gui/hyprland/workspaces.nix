{
  exo.mods.desktop = {
    my.hyprland.lua.files = {
      "workspaces".content = /* lua */ ''
        for i = 1, 5 do
          hl.workspace_rule({ workspace = i, persistent = true })
        end

        -- local workspace_names = {"web", "dev", "chat", "media", "steam"}
        -- for i, name in ipairs(workspace_names) do
        --   hl.workspace_rule({ workspace = name, persistent = true })
        --   hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = "name:" .. name }))
        --   hl.bind("SUPER + CTRL + " .. i, hl.dsp.window.move({ workspace = "name:" .. name }))
        -- end

        -- Switch workspaces with SUPER + [0-9]
        -- Move active window to a workspace with SUPER + CTRL + [0-9]
        -- Special workspaces with F1-10
        -- for i = #workspace_names + 1, 10 do
        for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        -- Named special workspaces
        for key, name in pairs({
          ["X"] = "scratch",
          ["S"] = "games",
          ["A"] = "rice",
          ["D"] = "dashboard"
        }) do
          hl.bind("SUPER + " .. key, hl.dsp.workspace.toggle_special(name))
          hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ workspace = "special:" .. name }))
        end

        hl.workspace_rule({
          workspace = 5,
          on_created_empty = "steam",
        })

        hl.workspace_rule({
          workspace = 5,
          on_created_empty = "xdg-open steam://open/friends",
        })

        hl.workspace_rule({
          workspace = "special:rice",
          layout = "lua:grid",
          border_size = 5,
          gaps_in = 10,
          gaps_out = 10,
          persistent = true,
        })

        hl.workspace_rule({
          workspace = "special:dashboard",
          gaps_in = 50,
          gaps_out = 50,
          border_size = 2,
          on_created_empty = "kitty -o font_size=18 -e todo",
          persistent = true,
        })

        hl.workspace_rule({
          workspace = "special:scratch",
          gaps_in = 25,
          gaps_out = 50,
          border_size = 2,
          on_created_empty = "kitty",
          persistent = true,
        })
      '';
    };
  };
}
