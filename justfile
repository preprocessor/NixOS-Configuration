vim:
  just nvim
nvim:
  nix run .#nixosConfigurations.ramiel.config.my.nixvim.package
tack:
  nix run .#write-tack
materialize:
  tack materialize
