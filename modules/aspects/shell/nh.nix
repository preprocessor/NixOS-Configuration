{
  flake.modules.nixos.default = {
    programs.nh = {
      enable = true;
      flake = "$HOME/Configuration/NixOS"; # sets NH_OS_FLAKE variable for you
      clean = {
        enable = true;
        extraArgs = "--keep-since 5d --keep 5";
      };
    };
  };
}
