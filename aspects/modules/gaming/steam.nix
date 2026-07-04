{
  w.gaming =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      custom.programs.hyprland.startup =
        let
          cfg = config.programs.steam;
        in
        [ ''hl.exec_cmd("${lib.getExe cfg.package}", { workspace = "name:steam" })'' ];

      custom.programs.hyprland.lua.files."window_rules.steam".content = /* lua */ ''
        hl.window_rule({
          name = "games-workspace-move-steam",
          match = {
            class = "^steam$",
            title = "negative:^(notificationtoasts_.*_desktop)$",
          },
          workspace = "special:steam",
        })

        hl.window_rule({
          name = "float-games-workspace",
          match = {
            title = "negative:^(Steam|Friends List)$",
            workspace = "special:steam",
          },

          size = { 1700, 1300 },
          center = true,
          float = true,
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
          name = "games-workspace-move-content",
          match = { content = "^game$" },
          workspace = "name:games silent",
          fullscreen = true,
        })
      '';

      environment.variables = {
        PROTON_ENABLE_WAYLAND = 1;
      };

      hardware.steam-hardware.enable = true; # controller / Steam Deck input udev rules
      programs.steam =
        let
          compatToolsDir = pkgs.linkFarm "me3-compat-tools" [
            {
              name = "proton-cachyos"; # me3 looks for the proton by this name
              path = pkgs.proton-cachyos.steamcompattool; # or whichever variant
            }
          ];
        in
        {
          enable = true;
          remotePlay.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
          # extraPackages = [ pkgs.latencyflex-vulkan ];
          extraCompatPackages = with pkgs; [
            steamtinkerlaunch
            proton-cachyos
          ];
          package = pkgs.steam.override {
            extraPkgs = fpkgs: [ pkgs.modengine3 ];
            extraEnv = {
              STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.concatStringsSep ":" [
                "${compatToolsDir}" # for ME3 / modengine3
                "\${HOME}/.steam/root/compatibilitytools.d"
                (lib.makeSearchPathOutput "steamcompattool" "" [ pkgs.proton-cachyos ])
              ];
            };
          };
        };
    };

}
