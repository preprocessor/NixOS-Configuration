{ inputs, ... }:
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-core.url = "github:manic-systems/nixos-core/refs/tags/v1.0.1"; # NixOS modules covering hardware quirks
  };

  w.default =
    {
      lib,
      constants,
      ...
    }:
    {
      imports = [ inputs.nixos-core.nixosModules.default ];

      nix.settings = {
        use-xdg-base-directories = true;
        warn-dirty = false;
        auto-optimise-store = true;
        allow-import-from-derivation = false;
        experimental-features = [
          "pipe-operators"
          "nix-command"
          "flakes"
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];

        extra-substituters = [
          "https://bazinga.cachix.org"
          "https://onelock.cachix.org"
        ];
        extra-trusted-public-keys = [
          "bazinga.cachix.org-1:WI9TV6l0gBVhcfY7OQM5zWqYmESIarKME0fjVN6yDYU="
          "onelock.cachix.org-1:Wyy9XrWqFKcPxkZXQg5yZXtsbKTbkaga44UWRJfgqEg="
        ];

      };

      services.speechd.enable = lib.mkForce false; # Disable tts

      nixpkgs.config = {
        allowUnfree = true;
        rocmSupport = true;
      };

      system.stateVersion = constants.stateVersion;

      services.dbus.implementation = "broker";

      services.power-profiles-daemon.enable = true;

      system.nixos-core.enable = true;
    };
}
