{
  modules.host.xyz =
    { config, ... }:
    {
      services.forgejo = {
        enable = true;
        user = "git";
        group = "git";
        stateDir = "/var/lib/forgejo";
        database.type = "sqlite3";
        settings = {
          server = {
            DOMAIN = "git.wyspr.xyz";
            ROOT_URL = "https://git.wyspr.xyz/";
            HTTP_ADDR = "127.0.0.1";
            HTTP_PORT = 3000;
            START_SSH_SERVER = false;
            SSH_DOMAIN = "git.wyspr.xyz";
            SSH_PORT = 22;
            SSH_USER = "git";
            SSH_ROOT_PATH = "/var/lib/forgejo/.ssh";
          };
          service.DISABLE_REGISTRATION = true;
          session.COOKIE_SECURE = true;
        };
      };

      users.groups.git = { };
      users.users.git = {
        isSystemUser = true;
        group = "git";
        home = "/var/lib/forgejo";
        useDefaultShell = true;
      };

      environment.systemPackages = [ config.services.forgejo.package ];
    };
}
