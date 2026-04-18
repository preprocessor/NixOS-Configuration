rec {
  flake = builtins.getFlake (toString ./.);
  nixos = flake.nixosConfigurations.ramiel.config;
}
