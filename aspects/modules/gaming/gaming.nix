{ inputs, ... }:
{
  tack.inputs.nix-gaming-edge.url = "gh:powerofthe69/nix-gaming-edge";

  exo.mods.gaming =
    {
      lib,
      pkgs,
      constants,
      ...
    }:
    {
      imports = [ inputs.nix-gaming-edge.nixosModules.default ];

      nix.settings = {
        substituters = [ "https://nix-cache.tokidoki.dev/tokidoki" ];
        trusted-public-keys = [ "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk=" ];
      };

      nixpkgs.overlays = [ inputs.nix-gaming-edge.overlays.default ];

      drivers.mesa-git = {
        enable = true;
        steamOrphanCleanup.enable = true;
        enableCache = false;
      };

      hj.environment.sessionVariables = {
        DXVK_ASYNC = "1";
        # Allow GPU render queueing
        DXGI_MAX_FRAME_LATENCY = "1";
        D3D9_MAX_FRAME_LATENCY = "1";
        PROTON_ENABLE_WAYLAND = 1;
        PROTON_NO_FSYNC = 1;
        PROTON_NTSYNC = 1;
      };

      hardware.amdgpu.overdrive.enable = true;

      # platformOptimizations.enable = true; from: https://github.com/fufexan/nix-gaming/blob/master/modules/platformOptimizations.nix
      boot.kernelModules = [ "ntsync" ];
      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "ntsync-udev-rules";
          text = ''KERNEL=="ntsync", MODE="0660", TAG+="uaccess"'';
          destination = "/etc/udev/rules.d/70-ntsync.rules";
        })
      ];

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
      };

      boot.kernelParams = [
        "pcie_aspm=off" # disables PCIe Active State Power Management (ASPM) across all PCIe links on the system
        "nowatchdog" # Disables the software watchdog, freeing up a tiny bit of CPU time
        "nmi_watchdog=0" # Disables the NMI watchdog
        "split_lock_detect=off" # Prevents the kernel from throttling games that use split locks

        "transparent_hugepage=madvise"
        "thp_anon=madvise"

        "processor.max_cstate=1" # disallow cores to go into deep sleep
        "idle=nomwait"
      ];

      services = {
        scx = {
          enable = true;
          package = pkgs.scx.rustscheds;
          scheduler = lib.mkForce "scx_cake"; # 🎂
        };
        lact.enable = true;
      };

      programs.gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10;
            softrealtime = "auto";
            ioprio = 0;
          };
          cpu = {
            governor = "performance";
            energy_perf_preference = "performance";
          };
          custom = {
            start = toString (
              pkgs.writeShellScript "gamemode-start" ''
                ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' -t 4000 -u low -i steam 'Enjoy the game' 'Praise the Sun!'
                # ( ${pkgs.coreutils}/bin/sleep 5 && ${pkgs.systemd}/bin/systemctl --user stop tuishell.service ) & disown
              ''
            );

            end = toString (
              pkgs.writeShellScript "gamemode-end" ''
                # ${pkgs.systemd}/bin/systemctl --user start tuishell.service
                # ${pkgs.coreutils}/bin/sleep 1
                ${pkgs.libnotify}/bin/notify-send -a 'Gamemode' -u low -i steam 'Game has been closed' 'Welcome home, Chosen Undead.'
              ''
            );
          };
        };
      };

      security.pam.loginLimits = [
        {
          domain = "@gamemode";
          item = "nice";
          type = "-";
          value = "-20";
        }
        {
          domain = constants.username;
          item = "rtprio";
          type = "-";
          value = "98";
        }
        {
          domain = constants.username;
          item = "nice";
          type = "-";
          value = "-20";
        }
        {
          domain = constants.username;
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
      ];

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          input-overlay
          obs-vaapi # better amd support
        ];
      };

      hj.packages = with pkgs; [
        prismlauncher # Minecraft
        dualsensectl # Dualsense Controller
        protonup-rs
        ckan # KSP mod loader
        me3
      ];

      _file = ./gaming.nix;
    };
}
