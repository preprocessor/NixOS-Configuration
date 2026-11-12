{ config, ... }:
{
  modules.configurations.ramiel = {
    user = "wyspr";
    stateVersion = "25.11";
    scheme = "amber";
    hardware = "desktop-pc";
    modules = with config.modules.features; [
      printing
      desktop
      gaming
      comms
    ];
  };
}
