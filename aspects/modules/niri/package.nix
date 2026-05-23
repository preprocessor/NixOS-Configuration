{
  ff.niri = {
    url = "github:niri-wm/niri";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  perSystem =
    { pkgs, inputs', ... }:
    {
      packages.niri = inputs'.niri.packages.niri.overrideAttrs (o: {
        patches = [
          # (pkgs.fetchpatch2 {
          #   name = "feat-layer-animations";
          #   url = "https://github.com/niri-wm/niri/pull/3481.patch";
          #   hash = "sha256-O3TNnppkT4ZsXkXHSzRzWj6k4nzLomjxNIz07GTnTOg=";
          # })
          ./patches/feat-add-focus-ring-fade-animation-and-gradient-rotation.patch # https://github.com/niri-wm/niri/pull/3577.patch
          ./patches/transparent-fullscreen.patch
        ];

        doCheck = false; # faster builds
      });

      _file = ./package.nix;
    };

  w.default =
    {
      birdee,
      self',
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.niri = {
        enable = true;
        package = birdee.wrappers.niri.wrap {
          inherit (config.wrappers.niri) settings;
          inherit pkgs;
          v2-settings = true;
          disableConfigHotReload = true;
          package = lib.mkForce self'.packages.niri;
        };
      };

      _file = ./package.nix;
    };
}
