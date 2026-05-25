{ inputs, ... }:
{
  ff.nix-gaming-edge = {
    url = "github:powerofthe69/nix-gaming-edge";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  w.desktop =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.nix-gaming-edge.nixosModules.default ];

      nix.settings = {
        substituters = [ "https://nix-cache.tokidoki.dev/tokidoki" ];
        trusted-public-keys = [ "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk=" ];
      };

      nixpkgs.overlays = with inputs.nix-gaming-edge.overlays; [
        proton-cachyos
        modengine3
        default
        pokemmo
      ];

      drivers.mesa-git = {
        enable = true;
        cacheCleanup = {
          # protonPackage is null by default - thus Proton caches are not cleaned by default. Must define a protonPackage to clear Proton / engine caches
          enable = true;
          protonPackage = pkgs.proton-cachyos;

          mesaCacheDirs = [
            # optional - default lists pre-configured
            "mesa_shader_cache*"
            "radv_builtin_shaders*"
            # etc.
          ];

          protonCacheFiles = [
            # optional - default lists pre-configured
            "vkd3d-proton.cache*"
            "shader*.cache"
            # etc.
          ];

          protonCacheDirs = [
            # optional - default lists pre-configured
            "*ShaderCache*"
            "D3DSCache*"
            # etc.
          ];
        };
        steamOrphanCleanup = {
          enable = true;
          protectedFolders = [
            # folders to not treat as orphans for deletion ( optional, pre-configured with smart defaults )
            "Proton*"
            "Steam Controller Configs"
            # etc.
          ];
        };
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

      programs.gamemode.enable = true;
      programs.gamescope = {
        enable = true;
        args = [
          "-W 3440"
          "-H 1440"
          # "-O ${config.primaryDisplay.name}"
          "-f"
        ];
      };

      hardware.amdgpu.overdrive.enable = true;

      # platformOptimizations.enable = true; from: https://github.com/fufexan/nix-gaming/blob/master/modules/platformOptimizations.nix
      boot.kernel.sysctl = {
        # 20-shed.conf
        "kernel.sched_cfs_bandwidth_slice_us" = 3000;
        # 20-net-timeout.conf
        # This is required due to some games being unable to reuse their TCP ports
        # if they're killed and restarted quickly - the default timeout is too large.
        "net.ipv4.tcp_fin_timeout" = 5;
        # 30-splitlock.conf
        # Prevents intentional slowdowns in case games experience split locks
        # This is valid for kernels v6.0+
        "kernel.split_lock_mitigate" = 0;
        # 30-vm.conf
        # USE MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
        # see comment i
      };

      services = {
        input-remapper.enable = true;
        system76-scheduler = {
          enable = true;
          useStockConfig = true;
        };
        scx = {
          enable = true;
          package = pkgs.scx.rustscheds;
          scheduler = lib.mkForce "scx_lavd"; # Gaming scheduler https://github.com/sched-ext/scx/blob/main/scheds/rust/README.md
        };
        lact.enable = true;
      };

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          input-overlay
          obs-vaapi # better amd support
        ];
      };

      hj.packages = with pkgs; [
        protontricks
        prismlauncher # Minecraft
        bolt-launcher # Runescape
        dualsensectl # Dualsense Controller
        ckan # KSP mod loader
        pokemmo
        modengine3
      ];

      _file = ./gaming.nix;
    };
}
