{ config, ... }:
{
  exo.configurations = {
    ramiel = {
      user = "wyspr";
      stateVersion = "25.11";
      scheme = "magi";
      hardware = "desktop-pc";
      modules = with config.exo.mods; [
        printing
        desktop
        gaming
        comms
      ];
    };
  };
}
