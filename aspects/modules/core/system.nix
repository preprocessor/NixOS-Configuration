{
  tack.inputs.nixpkgs.url = "nixpkgs:unstable";

  exo.core =
    { constants, ... }:
    {
      system.stateVersion = constants.stateVersion;

      nixpkgs.config = {
        allowUnfree = true;
        rocmSupport = true;
      };

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
      };
    };
}
