{ config, ... }: {
  modules.configurations.xyz = {
    user = "wyspr";
    stateVersion = "25.11";
    scheme = "amber";
    hardware = "xyz-vps";
    modules = with config.modules.features; [
      # server
    ];
  };
}
