{
  modules.host.xyz = {
    services.nginx = {
      enable = true;
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
            proxyPass = "http://127.0.0.1:5000";
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
