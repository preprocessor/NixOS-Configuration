vm:
  nh os build-vm . --diff always
  ./result/bin/run-ramiel-vm

check:
  statix

format:
  nixfmt **/*.nix
