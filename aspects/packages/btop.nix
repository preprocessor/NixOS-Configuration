{
  perSystem = { pkgs, ... }: {
    remotePackages.btop = pkgs.btop-rocm.overrideAttrs (o: {
      doCheck = false;
      patches = (o.patches or [ ]) ++ [
        (pkgs.fetchpatch2 {
          name = "normalize_processes_from_nix_store";
          url = "https://raw.githubusercontent.com/NotAShelf/nyxexprs/refs/heads/main/pkgs/btop/patches/normalize_processes.patch";
          hash = "sha256-dh3TTb0Ix983W50inTzGflQ7mpBELaKReBUmzjBixTo=";
        })
      ];
    });
  };
}
