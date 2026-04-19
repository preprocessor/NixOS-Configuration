{ lib, self, ... }:
{
  ff = {
    # channel urls are faster and more reliable than github
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-stable.url = "https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz";
    nixos-hardware.url = "github:NixOS/nixos-hardware"; # NixOS modules covering hardware quirks
  };

  w.default =
    { pkgs, ... }:
    {
      nix.settings = {
        use-xdg-base-directories = true;
        warn-dirty = false;
        auto-optimise-store = true;
        experimental-features = [
          "pipe-operators"
          "nix-command"
          "flakes"
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];

        extra-substituters = [ "https://bazinga.cachix.org" ];
        extra-trusted-public-keys = [ "bazinga.cachix.org-1:WI9TV6l0gBVhcfY7OQM5zWqYmESIarKME0fjVN6yDYU=" ];
      };

      nix.optimise.automatic = true;
      nix.optimise.dates = [ "19:30" ];

      services.scx = {
        enable = true;
        package = pkgs.scx.rustscheds;
        # [INFO] https://github.com/sched-ext/scx/blob/main/scheds/rust/scx_lavd/README.md
        scheduler = "scx_lavd";
      };

      nixpkgs = {
        config = {
          allowUnfree = true;
          rocmSupport = true;
        };

        # pkgs.sys = pkgs.stdenv.hostPlatform.system
        overlays = [ (f: p: { sys = p.stdenv.hostPlatform.system; }) ];
      };

      system.stateVersion = self.const.stateVersion;

      services.dbus.implementation = "broker";

      programs.nano.enable = lib.mkForce false; # Take out the trash

      # This is a workaround to set NIXOS_OZONE_WL as described in https://wiki.nixos.org/wiki/Wayland#Electron_and_Chromium
      hj.environment.sessionVariables.NIXOS_OZONE_WL = "1";

      gtk.iconCache.enable = true;

      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
}
