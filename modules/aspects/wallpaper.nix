{
  flake.modules.homeManager.wayland =
    { lib, ... }:
    {
      services.swww.enable = true;
      systemd.user.services.swww.Unit.ConditionEnvironment = lib.mkForce "";

    };
}
