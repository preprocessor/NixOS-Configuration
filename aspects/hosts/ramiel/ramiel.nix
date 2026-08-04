{ config, ... }:
{
  exo.configurations = {
    ramiel = {
      user = "wyspr";
      stateVersion = "25.11";
      hardware = "desktop-pc";
      theme = "light";
      modules = with config.exo.mods; [
        printing
        desktop
        gaming
        comms
      ];
    };
  };
}
