{
  exo.mods.gaming = {
    my.hyprland.windowrules.steam = [
      {
        name = "games-workspace-move-steam";
        match = {
          class = "^steam$";
          title = "negative:^(notificationtoasts_.*_desktop)$";
        };
        rules.workspace = "special:steam";
      }

      {
        name = "more-move-steam";
        match = {
          class = "^steam$";
          title = "^$";
        };
        rules.workspace = "special:steam";
      }

      {
        name = "float-games-workspace";
        match = {
          title = "negative:^(Steam|Friends List)$";
          workspace = "special:steam";
        };
        rules.float = true;
      }

      {
        name = "float-non-steam-apps-games-workspace";
        match = {
          title = "negative:^(Steam|Friends List)$";
          class = "negative:^steam$";
          workspace = "special:steam";
        };
        rules = {
          size = [
            1700
            1300
          ];
          center = true;
        };
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
          workspace = "name:games silent";
          fullscreen = true;
          content = "game";
        };
      }

      {
        name = "games-workspace-move-class";
        match.class = "^steam_app_.*";
        rules = {
          workspace = "name:games silent";
          fullscreen = true;
          content = "game";
        };
      }

      {
        name = "games-workspace-move-darksouls";
        match = {
          class = "darksoulsremastered.exe";
          title = "DARK SOULS™: REMASTERED";
        };
        rules = {
          workspace = "name:games silent";
          render_unfocused = true;
          fullscreen = true;
          content = "game";
        };
      }

      {
        name = "games-workspace-move-content";
        match.content = "game";
        rules = {
          workspace = "name:games silent";
          fullscreen = true;
        };
      }
    ];

    _file = ./window_rules.nix;
  };

}
