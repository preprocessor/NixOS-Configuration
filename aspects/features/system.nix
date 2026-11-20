{
  tack.inputs.nixpkgs = {
    url = "nixpkgs:unstable";
    group = "nix";
  };

  modules.features.rocm = {
    nixpkgs.config.rocmSupport = true;
  };

  modules.core = { constants, ... }: {
    system.stateVersion = constants.stateVersion;

    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      use-xdg-base-directories = true;
      warn-dirty = false;
      auto-optimise-store = true;
      allow-import-from-derivation = false;

      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
