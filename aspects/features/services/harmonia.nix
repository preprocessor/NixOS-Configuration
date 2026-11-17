{
  modules.host.xyz =
    { config, ... }:
    {
      services.harmonia.cache = {
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

      systemd.tmpfiles.rules = [
        "d /var/lib/harmonia-cache 0755 wyspr users - -"
      ];
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
