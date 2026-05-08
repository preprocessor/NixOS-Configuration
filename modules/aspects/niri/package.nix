{
  ff.niri = {
    url = "github:niri-wm/niri";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  perSystem =
    { pkgs, inputs', ... }:
    {
      packages.niri = inputs'.niri.packages.niri.overrideAttrs (o: ({
        # patches = [
        #   (pkgs.fetchpatch2 {
        #     name = "focus_ring_fade_animation_and_gradient_rotation.patch";
        #     url = "https://github.com/niri-wm/niri/pull/3838.patch";
        #     hash = "sha256-I6ZrfeWUFYB+USP3qOkLvONJyQQVxybFZp6m4cJcDFw=";
        #   })
        # ];

        doCheck = false; # faster builds
      }));

    };

  w.default =
    {
      wrappers,
      self',
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.niri = {
        enable = true;
        package = wrappers.wrappers.niri.wrap {
          inherit (config.wrappers.niri) settings;
          inherit pkgs;
          v2-settings = false;
          package = lib.mkForce self'.packages.niri;
        };
      };
    };
}
