{
  exo.mods.desktop = {
    my.hyprland.lua.files = {
      "workspaces".content = /* lua */ ''
        for i = 1, 5 do
          hl.workspace_rule({ workspace = tostring(i), persistent = true })
        end

        hl.workspace_rule({
          workspace = "special:steam",
          layout = "lua:steam",
          gaps_in = 50,
          gaps_out = 50,
          border_size = 2,
          on_created_empty = "steam"
        })

        hl.workspace_rule({
          workspace = "special:rice",
          layout = "lua:grid",
          border_size = 5,
          gaps_in = 10,
          gaps_out = 10,
          on_created_empty = "steam"
        })

        hl.workspace_rule({
          workspace = "special:dashboard",
          gaps_in = 50,
          gaps_out = 50,
          border_size = 2,
          on_created_empty = "kitty -o font_size=18 -e todo"
        })

        hl.workspace_rule({
          workspace = "special:scratch",
          gaps_in = 25,
          gaps_out = 50,
          border_size = 2,
          on_created_empty = "kitty"
        })
      '';
    };
  };
}
