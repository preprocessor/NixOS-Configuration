{
  perSystem = { pkgs, ... }: {
    remotePackages.kitty = pkgs.kitty.overrideAttrs (o: {
      doCheck = false;
      patches = (o.patches or [ ]) ++ [
        (pkgs.fetchpatch2 {
          name = "kitty_shade_blocks";
          url = "https://gist.githubusercontent.com/preprocessor/b9a2c16d7df4a8ba0c02d1821887de50/raw/fc89ab6edfcd475915532219c40391263325bad4/shade-blocks.patch";
          hash = "sha256-caFaoUEpuF/stamyCFVtmrpfbRc1/2FWnt+slAVPopQ=";
        })
      ];
    });
  };
}
