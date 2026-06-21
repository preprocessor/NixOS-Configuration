
vim:
  just nvim
nvim:
  nix flake update neovim --offline
  nh os test --offline
