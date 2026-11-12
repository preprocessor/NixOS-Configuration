{
  perSystem = { pkgs, ... }: {
    remotePackages.gtop = pkgs.amdgpu_top.overrideAttrs (oldAttrs: {
      doCheck = false;
      cargoBuildFlags = (oldAttrs.cargoBuildFlags or [ ]) ++ [
        "--no-default-features"
        "--features"
        "tui,libamdgpu_top/libdrm_link"
      ];
    });
  };
}
