{ lib, self, ... }:
{
  flake-file.inputs = {
    systems.url = "github:nix-systems/x86_64-linux";
    flake-utils.inputs.systems.follows = "systems";
    # channel urls are faster and more reliable than github
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-stable.url = "https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz";
    nixos-hardware.url = "github:NixOS/nixos-hardware"; # NixOS modules covering hardware quirks
  };

  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      nix.settings = {
        use-xdg-base-directories = true;
        warn-dirty = false;
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      services.scx = {
        enable = true;
        package = pkgs.scx.rustscheds;
        scheduler = "scx_lavd";
      };

      nixpkgs.config = {
        allowUnfree = true;
        rocmSupport = true;
      };

      system.stateVersion = self.const.stateVersion;

      services.dbus.implementation = "broker";

      programs.nano.enable = lib.mkForce false; # Take out the trash

      # This is a workaround to set NIXOS_OZONE_WL as described in https://wiki.nixos.org/wiki/Wayland#Electron_and_Chromium
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
}
