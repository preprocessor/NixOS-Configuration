{
  modules.core = {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 5d --keep 5";
      };
    };
  };

  modules.host.ramiel = {
    programs.nh.flake = "$HOME/Configuration/NixOS"; # sets NH_FLAKE variable for you
  };
}
