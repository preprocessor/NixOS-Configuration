{ self, ... }:
{
  w.default =
    { pkgs, ... }:
    {
      virtualisation.docker.enable = true;
      users.groups.docker = { };
      users.users."${self.const.username}".extraGroups = [ "docker" ];
      environment.systemPackages = [ pkgs.winboat ];
    };
}
