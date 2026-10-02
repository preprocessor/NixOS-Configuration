{
  exo.mods.winboat =
    { constants, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.winboat ];

      virtualisation.docker.enable = true;
      users.groups.docker = { };
      users.users."${constants.username}".extraGroups = [ "docker" ];
    };
}
