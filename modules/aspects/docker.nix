{
  w.default =
    { pkgs, constants, ... }:
    {
      virtualisation.docker.enable = true;
      users.groups.docker = { };
      users.users."${constants.username}".extraGroups = [ "docker" ];
      environment.systemPackages = [ pkgs.winboat ];
    };
}
