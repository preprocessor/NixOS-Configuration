{
  exo.mods.gaming = {
    my.hyprland.windowrules.steam = [
      {
        name = "move-steam-windows-to-ws";
        match = {
          class = "^steam$";
          title = "negative:^(notificationtoasts_.*_desktop)$";
        };
        rules.workspace = "5 silent";
      }

      {
        name = "more-move-steam";
        match = {
          class = "^steam$";
          title = "^$";
        };
        rules.workspace = "5 silent";
      }

      {
        name = "hide-steam-settings-from-stream";
        match = {
          title = "^Steam Settings$";
          class = "^steam$";
        };
        rules.tag = "+hidden";
      }

      {
        name = "games-workspace-move-tag";
        match.xdg_tag = "^proton-game$";
        rules = {
          workspace = "5 silent";
          fullscreen = true;
          content = "game";
        };
      }

      {
        name = "games-workspace-move-class";
        match.class = "^steam_app_.*";
        rules = {
          workspace = "5 silent";
          fullscreen = true;
          content = "game";
        };
      }

      {
        name = "games-workspace-darksouls";
        match = {
          class = "darksoulsremastered.exe";
          title = "DARK SOULS™: REMASTERED";
        };
        rules = {
          workspace = "5 silent";
          render_unfocused = true;
          fullscreen = true;
          content = "game";
        };
      }

      {
        name = "games-workspace-darksouls2";
        match.title = "DARK SOULS II";
        rules = {
          workspace = "5 silent";
          render_unfocused = true;
          fullscreen = true;
          content = "game";
        };
      }

      {
        name = "games-workspace-move-content";
        match.content = "game";
        rules.workspace = "5 silent";
      }
    ];

    _file = ./window_rules.nix;
  };

}
