{ inputs, ... }:
{
  flake-file.inputs.nix-gaming.url = "github:fufexan/nix-gaming";

  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-gaming.nixosModules.pipewireLowLatency
        inputs.nix-gaming.nixosModules.platformOptimizations
      ];

      nix.settings = {
        substituters = [ "https://nix-gaming.cachix.org" ];
        trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
      };

      environment.systemPackages = with pkgs; [
        protonup-ng
      ];

      environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      };

      programs.steam = {
        enable = true;
        platformOptimizations.enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        extraPackages = [ pkgs.latencyflex-vulkan ];
        extraCompatPackages = with pkgs; [
          steamtinkerlaunch
        ];
      };

      programs.gamemode.enable = true;
      programs.gamescope = {
        enable = true;
        args = [
          "-W 3440"
          "-H 1440"
          "-r 75"
          # "-O ${hostConfig.primaryDisplay.name}"
          "-f"
          "--adaptive-sync"
        ];
      };

      hardware.steam-hardware.enable = true;

      services = {
        # pipewire.lowLatency.enable = true;
        input-remapper.enable = true;
        system76-scheduler.enable = true;
      };
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          input-overlay
        ];
      };

      home.packages = with pkgs; [
        prismlauncher # Minecraft
        runelite # Runescape
        bolt-launcher # Runescape
        dualsensectl # Dualsense Controller
        bottles # Wine manager
        wine
      ];
    };
}
