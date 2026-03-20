{ self, ... }:
{
  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware"; # NixOS modules covering hardware quirks
  };

  flake.modules.nixos.default =
    { lib, ... }:
    {
      system.stateVersion = self.const.stateVersion;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nix.settings.trusted-users = [
        "root"
        "@wheel"
      ];

      services.dbus.implementation = "broker"; # more like broken

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.rocmSupport = true;

      programs.nano.enable = lib.mkForce false; # Take out the trash

      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
}
