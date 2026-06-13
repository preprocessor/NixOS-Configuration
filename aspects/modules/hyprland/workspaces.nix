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
      '';
    };
  };
}
