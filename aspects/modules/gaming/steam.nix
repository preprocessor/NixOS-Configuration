{
  w.desktop =
    { pkgs, lib, ... }:
    {
      wrappers.hyprland.lua.files."window_rules".content = /* lua */ ''
        hl.window_rule({
          name = "games-workspace-move",
          match = { class = "^steam$" },
          workspace = "name:games silent",
        })

        hl.window_rule({
          name = "float-steam-sub-windows",
          match = {
            title = "^(Friends List|Controller Layout|Steam Controller Configs|SteamTinkerLaunch.*)$",
            class = "^steam$",
          },

          float = true,
        })

        hl.window_rule({
          name = "hide-steam-windows",
          match = {
              title = "^Steam Settings$",
            class = "^steam$",
          },
          border_color = "rgb(fede22)",
          border_size = 3,

          float = true,
          no_screen_share = true,
        })
      '';

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
