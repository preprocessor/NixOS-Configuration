{
  perSystem =
    { pkgs, ... }:
    {
      packages.amdgpu_top = pkgs.amdgpu_top.overrideAttrs (oldAttrs: {
        doCheck = false;
        cargoBuildFlags = (oldAttrs.cargoBuildFlags or [ ]) ++ [
          "--no-default-features"
          "--features"
          "tui,libamdgpu_top/libdrm_link"
        ];
      });
    };

  w.default =
    { self', ... }:
    {
      nixpkgs.overlays = [ (_: _: { amdgpu_top = self'.packages.amdgpu_top; }) ];
    };
}
