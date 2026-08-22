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

      hardware.steam-hardware.enable = true; # controller / Steam Deck input udev rules
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        # Defaults to system fonts, its instead set to a specific list to avoid rebuilding the derivation upon font changes
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
