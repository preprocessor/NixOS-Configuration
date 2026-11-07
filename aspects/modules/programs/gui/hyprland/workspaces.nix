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
        for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        -- Named special workspaces
        for key, name in pairs({
          ["X"] = "scratch",
          ["G"] = "games",
          ["D"] = "dashboard"
        }) do
          hl.workspace_rule({
            workspace = "special:" .. name,
            persistent = true,
          })

          hl.bind("SUPER + " .. key, hl.dsp.workspace.toggle_special(name))
          hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ workspace = "special:" .. name }))
        end

        local on_created_empty = function(ws)
          local selector = ws.id or ws.name

          local ws_exec = function(cmd)
            hl.dispatch(hl.dsp.exec_cmd(cmd, { workspace = selector }))
          end

          local workspace_action = {
            [5] = function()
              ws_exec("steam")
              ws_exec("xdg-open steam://open/friends")
            end,

            ["special:dashboard"] = function()
              ws_exec("kitty -o font_size=18 -e nvim ~/todo.md")
            end,

            ["special:scratch"] = function()
              ws_exec("kitty")
            end,
          }

          workspace_action[selector]()
        end

        local any_workspace_active = function(ws)
          if not ws then
            return
          end
          if ws.windows == 0 then
            on_created_empty(ws)
          end
        end

        hl.on("workspace.active", any_workspace_active)
        hl.on("workspace.special_active", any_workspace_active)

        hl.bind("SUPER + A", hl.dsp.workspace.toggle_special("rice"))
        hl.bind("SUPER + CTRL + A", hl.dsp.window.move({ workspace = "special:rice" }))

        hl.workspace_rule({
          workspace = "special:rice",
          layout = "lua:grid",
          persistent = true,
        })

        hl.workspace_rule({
          workspace = "s[true]",
          persistent = true,
          gaps_in = 10,
          gaps_out = 20,
        })
      '';
    };
  };
}
