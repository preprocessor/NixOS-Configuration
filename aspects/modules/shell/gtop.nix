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

  exo.mods.gaming =
    { self', lib, ... }:
    {
      programs.fish.shellAliases.gtop = lib.getExe self'.packages.amdgpu_top;
    };
}
