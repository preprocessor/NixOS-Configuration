{ inputs, self, ... }:
{
  ff.nix-cachyos-kernel = {
    url = "github:xddxdd/nix-cachyos-kernel/release";
    inputs.flake-parts.follows = "flake-parts";
  };

  w.default =
    { pkgs, config, ... }:
    {
      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

      nix.settings.substituters = [
        "https://attic.xuyh0120.win/lantian"
        "https://cache.garnix.io"
      ];
      nix.settings.trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];

      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

      systemd.timers."catchy-os" = {
        description = "Build CatchyOS Kernel";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*-*-* 4:00:00";
          Persistent = true;
          Unit = "catchy-os.service";
        };
      };

      systemd.user.services."catchy-os" = {
        path = with pkgs; [
          nix
          cachix
        ];

        script = /* bash */ ''
          set -euo pipefail

          FLAKE_DIR=${self.const.cfgdir}
          CACHE_NAME=bazinga
          CACHE_URL=https://bazinga.cachix.org

          cd "$FLAKE_DIR"

          KERNEL_OUT=$(nix eval --raw \
            .#nixosConfigurations.ramiel.config.boot.kernelPackages.kernel)

          if nix path-info --store "$CACHE_URL" "$KERNEL_OUT" >/dev/null 2>&1; then
            echo "Already cached — skipping."
            exit 0
          fi

          nix build .#nixosConfigurations.ramiel.config.boot.kernelPackages.kernel \
            --print-out-paths \
            --no-link \
            | cachix push "$CACHE_NAME"
        '';

        serviceConfig = {
          EnvironmentFile = config.sops.secrets.private_key.path;
          Type = "oneshot";
          User = "wyspr";
        };
      };
    };
}
