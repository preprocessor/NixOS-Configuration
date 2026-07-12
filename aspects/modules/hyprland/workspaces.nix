{
  w.desktop = {
    my.hyprland.lua.files = {
      "workspaces".content = /* lua */ ''
        for index, name in ipairs({ "web", "dev", "chat", "media", "games" }) do
          hl.workspace_rule({ workspace = tostring(index), default_name = name, persistent = true })
        end

        hl.workspace_rule({ workspace = "name:web", layout = "scrolling" })

        hl.window_rule({
          name   = "floating-media-workspace",
          match  = { workspace = "name:media" },

          size   = { 1200, 1200 },
          center = true,
          float  = true,
        })

        hl.workspace_rule({
          workspace = "special:steam",
          layout = "lua:steam",
          border_size = 5,
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
          border_size = 5,
          on_created_empty = "kitty -o font_size=18 -e todo"
        })

        hl.workspace_rule({
          workspace = "special:scratch",
          gaps_in = 25,
          gaps_out = 50,
          border_size = 5,
          on_created_empty = "kitty"
        })
      '';
    };
  };
}
