{
  modules.core = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.attic-client ];
  };

  modules.host.xyz =
    { config, ... }:
    {
      services.atticd = {
        enable = true;
        environmentFile = config.sops.templates."atticd.env".path;
        settings = {
          listen = "127.0.0.1:8080";
          "allowed-hosts" = [ "attic.wyspr.xyz" ];
          "api-endpoint" = "https://attic.wyspr.xyz/";
        };
      };

      sops.templates."atticd.env".content = ''
        ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=${config.sops.placeholder.attic_rs256_secret}
      '';
    };

  modules.features.desktop = {
    nix.settings = {
      substituters = [ "https://attic.wyspr.xyz/main" ];
      trusted-public-keys = [ "main:Rz328YhW+fhUPvBBhMyJyaF6XVOTh5oAzMKr0RO3ySQ=" ];
    };
  };
}
