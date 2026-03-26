{ lib, self, ... }:
{
  flake.modules.nixos.default = {
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

    # This is a workaround to set NIXOS_OZONE_WL as described in https://wiki.nixos.org/wiki/Wayland#Electron_and_Chromium
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
