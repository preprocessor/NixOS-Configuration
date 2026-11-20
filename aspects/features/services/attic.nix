{
  modules.host.xyz =
    { config, pkgs, ... }:
    {
      services.atticd = {
        enable = true;
        environmentFile = config.sops.templates."atticd.env".path;
        settings = {
          listen = "127.0.0.1:8080";
          "allowed-hosts" = [ "cache.wyspr.xyz" ];
          "api-endpoint" = "https://cache.wyspr.xyz/";
          "garbage-collection" = {
            interval = "12 hours";
            "default-retention-period" = "30 days";
          };
        };
      };

      sops.templates."atticd.env".content = ''
        ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=${config.sops.placeholder.attic_rs256_secret}
      '';

      environment.systemPackages = [ pkgs.attic-client ];
    };

  modules.features.desktop = {
    nix.settings = {
      trusted-substituters = [ "https://cache.wyspr.xyz/main" ];
      trusted-public-keys = [
        "main:Rz328YhW+fhUPvBBhMyJyaF6XVOTh5oAzMKr0RO3ySQ="
      ];
    };
  };
}
