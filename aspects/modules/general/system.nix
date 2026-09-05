{ inputs, ... }:
{
  tack.inputs = {
    nixpkgs.url = "nixpkgs:unstable";
    nixos-core.url = "gh:manic-systems/nixos-core/refs/tags/v1.0.1";
  };

  exo.core =
    {
      constants,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ inputs.nixos-core.nixosModules.default ];
      system.nixos-core.enable = true;

      nix.package = pkgs.nixVersions.latest;

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

        extra-substituters = [ "https://onelock.cachix.org" ];
        extra-trusted-public-keys = [ "onelock.cachix.org-1:Wyy9XrWqFKcPxkZXQg5yZXtsbKTbkaga44UWRJfgqEg=" ];
      };

      services.speechd.enable = lib.mkForce false; # Disable tts

      nixpkgs.config = {
        allowUnfree = true;
        rocmSupport = true;
      };

      system.stateVersion = constants.stateVersion;

      services.dbus.implementation = "broker";

      services.power-profiles-daemon.enable = true;
    };
}
