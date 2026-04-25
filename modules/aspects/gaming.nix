{ inputs, ... }:
{
  ff.nix-gaming = {
    url = "github:fufexan/nix-gaming";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-parts.follows = "flake-parts";
  };

  w.desktop =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-gaming.nixosModules.platformOptimizations ];

      nix.settings = {
        substituters = [ "https://nix-gaming.cachix.org" ];
        trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
      };

      environment.systemPackages = with pkgs; [
        protonup-rs
      ];

      hj.environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

      programs.steam = {
        enable = true;
        platformOptimizations.enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        extraPackages = [ pkgs.latencyflex-vulkan ];
        extraCompatPackages = [ pkgs.steamtinkerlaunch ];
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
        input-remapper.enable = true;
        system76-scheduler.enable = true;
      };

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          input-overlay
        ];
      };

      hj.packages = with pkgs; [
        prismlauncher # Minecraft
        runelite # Runescape
        bolt-launcher # Runescape
        dualsensectl # Dualsense Controller
      ];
    };
}
