{ self, ... }:
{
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

      services.dbus.implementation = "dbus"; # more like broken

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.rocmSupport = true;

      programs.nano.enable = lib.mkForce false; # Take out the trash

      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
}
