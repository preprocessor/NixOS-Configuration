{
  exo.mods.gaming =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      my.hyprland.startup =
        let
          cfg = config.programs.steam;
        in
        [ ''hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "name:steam silent" })'' ];

      my.hyprland.lua.files."window_rules.steam".content = /* lua */ ''
        hl.window_rule({
          name = "games-workspace-move-steam",
          match = {
            class = "^steam$",
            title = "negative:^(notificationtoasts_.*_desktop)$",
          },
          workspace = "special:steam",
        })

        hl.window_rule({
          name = "more-move-steam",
          match = {
            class = "^steam$",
            title = "^$",
          },
          workspace = "special:steam",
        })

        hl.window_rule({
          name = "float-games-workspace",
          match = {
            title = "negative:^(Steam|Friends List)$",
            workspace = "special:steam",
          },

          float = true,
        })

        hl.window_rule({
          name = "float-games-workspace",
          match = {
            title = "negative:^(Steam|Friends List)$",
            class = "negative:^steam$",
            workspace = "special:steam",
          },

          size = { 1700, 1300 },
          center = true,
        })

        hl.window_rule({
          name = "hide-steam-settings-from-stream",
          match = {
            title = "^Steam Settings$",
            class = "^steam$",
          },

          tag = "+hidden"
        })

        hl.window_rule({
          name = "games-workspace-move-tag",
          match = { xdg_tag = "^proton-game$" },
          workspace = "name:games silent",
          fullscreen = true,
          content = "game",
        })

        hl.window_rule({
          name = "games-workspace-move-class",
          match = { class = "^steam_app_.*" },
          workspace = "name:games silent",
          fullscreen = true,
          content = "game",
        })

        hl.window_rule({
          name = "games-workspace-move-darksouls",
          match = {
            class = "darksoulsremastered.exe",
            title = "DARK SOULS™: REMASTERED",
          },
          workspace = "name:games silent",
          render_unfocused = true,
          fullscreen = true,
          content = "game",
        })

        hl.window_rule({
          name = "games-workspace-move-content",
          match = { content = "game" },
          workspace = "name:games silent",
          fullscreen = true,
        })
      '';

      environment.variables = {
        PROTON_ENABLE_WAYLAND = 1;
      };

      hardware.steam-hardware.enable = true; # controller / Steam Deck input udev rules
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        fontPackages = with pkgs; [
          noto-fonts-color-emoji
          noto-fonts-cjk-sans
          noto-fonts
        ];
        # extraPackages = [ pkgs.latencyflex-vulkan ];
        # extraCompatPackages = with pkgs; [
        #   steamtinkerlaunch
        # ];
        package = pkgs.steam.override {
          extraPkgs = fpkgs: [ pkgs.modengine3 ];
          extraEnv = {
            STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.join ":" [
              "\${HOME}/.steam/root/compatibilitytools.d"
            ];
          };
        };
      };

      _file = ./steam.nix;
    };

}
