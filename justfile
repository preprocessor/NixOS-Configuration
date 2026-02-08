build:
	nixos-rebuild switch --sudo --flake .

test:
	nixos-rebuild test --flake .

nvim:
	nix profile add ".#nvim"
