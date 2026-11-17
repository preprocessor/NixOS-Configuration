{
  modules.host.ramiel = { config, ... }: {
    my.attic-client = {
      enable = true;
      settings = {
        default-server = "xyz";
        servers.xyz = {
          endpoint = "https://attic.wyspr.xyz";
          token-file = config.sops.secrets.attic_token.path;
        };
      };
    };
  };
}
