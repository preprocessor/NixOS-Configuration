{
  modules.host.xyz =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      gcScript = pkgs.writeShellApplication {
        name = "harmonia-cache-gc";
        runtimeInputs = [
          config.nix.package
          pkgs.coreutils
        ];
        text = ''
          set -euo pipefail

          store=/var/lib/harmonia-cache
          manifest="$store/keep.txt"
          roots=$(mktemp -d)
          trap 'rm -rf "$roots"' EXIT

          if [ ! -s "$manifest" ]; then
            echo "No keep manifest at $manifest; refusing to prune." >&2
            exit 0
          fi

          count=0
          while IFS= read -r path; do
            [ -n "$path" ] || continue
            if nix path-info --store "$store" "$path" >/dev/null 2>&1; then
              count=$((count + 1))
              nix-store --store "$store" --add-root "$roots/$count" --indirect -r "$path" >/dev/null
            else
              echo "Skipping missing path: $path" >&2
            fi
          done < "$manifest"

          if [ "$count" -eq 0 ]; then
            echo "No manifest paths are present in the cache; refusing to prune." >&2
            exit 0
          fi

          args=(--store-dir "$store/nix/store" --state-dir "$store/nix/var/nix")
          if [ "''${DRY_RUN:-0}" = "1" ]; then
            args+=(--dry-run)
          fi

          ${lib.getExe' config.services.harmonia.package "harmonia-gc"} "''${args[@]}"
        '';
      };
    in
    {
      services.harmonia = {
        cache = {
          enable = true;
          signKeyPaths = [ config.sops.secrets.harmonia_signing_key.path ];
          settings = {
            bind = "127.0.0.1:5000";
            priority = 41;
            real_nix_store = "/var/lib/harmonia-cache/nix/store";
            nix_db_path = "/var/lib/harmonia-cache/nix/var/nix/db/db.sqlite";
            virtual_nix_store = "/nix/store";
          };
        };

        gc = {
          enable = true;
          automatic = true;
          dates = "Mon *-*-* 00:00:00";
        };
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/harmonia-cache 0755 wyspr users - -"
      ];

      systemd.services.harmonia-cache-gc = {
        description = "Prune the Harmonia cache to the current remote package set";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.getExe gcScript;
        };
      };

      systemd.timers.harmonia-cache-gc = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "Mon *-*-* 04:00:00";
          Persistent = true;
          RandomizedDelaySec = "1h";
        };
      };
    };

  modules.features.desktop = {
    nix.settings = {
      extra-substituters = [ "https://cache.wyspr.xyz" ];
      extra-trusted-public-keys = [
        "cache.wyspr.xyz-1:5XA+mlpNBkL+9Qy1tDvJziPo7ZAyA9krywyWl3xeXYc="
      ];
    };
  };
}
