{
  exo.mods.winboat =
    { pkgs, constants, ... }:
    {
      virtualisation.docker.enable = true;
      virtualisation.podman.enable = true;

      users.groups.docker = { };
      users.users."${constants.username}".extraGroups = [ "docker" ];
      environment.systemPackages = [ pkgs.winboat ];
    };
}
