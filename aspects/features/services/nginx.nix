{
  modules.host.xyz =
    { pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        package = pkgs.nginxStable.overrideAttrs {
          version = "1.30.7";
          src = pkgs.fetchurl {
            url = "https://nginx.org/download/nginx-1.30.7.tar.gz";
            hash = "sha256-JWW1yDcFDpWPcPsPc8SOK8pFQq00n9NW9G+wxyYQvG4=";
          };
        };
        clientMaxBodySize = "0";
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        virtualHosts = {
          "git.wyspr.xyz" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:3000";
              proxyWebsockets = true;
            };
          };
          "cache.wyspr.xyz" = {
            enableACME = true;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:8080";
              extraConfig = "proxy_request_buffering off;";
            };
          };
        };
      };

      security.acme.defaults.email = "wyspr+acme@wyspr.xyz";
      security.acme.acceptTerms = true;
      networking.enableIPv6 = false;
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    };
}
