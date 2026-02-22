default: test

# boot  -  Build the new configuration and make it the boot default
boot:
  nh os boot --ask --diff always

# test  -  Build and activate the new configuration
test:
  nh os test --ask --diff always

vm:
  nh os build-vm . --diff always
  ./result/bin/run-ramiel-vm

check:
  nix flake check --show-trace

format:
  nixfmt **/*.nix
