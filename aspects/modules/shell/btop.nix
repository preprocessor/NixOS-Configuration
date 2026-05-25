{
  perSystem =
    { pkgs, ... }:
    {
      packages.btop = pkgs.btop-rocm.overrideAttrs {
        patches = [
          (pkgs.fetchpatch2 {
            name = "normalize_processes";
            url = "https://raw.githubusercontent.com/NotAShelf/nyxexprs/refs/heads/main/pkgs/btop/patches/normalize_processes.patch";
            hash = "sha256-dh3TTb0Ix983W50inTzGflQ7mpBELaKReBUmzjBixTo=";
          })
        ];
      };
    };

  w.default =
    { self', ... }:
    {
      hj.packages = [ self'.packages.btop ];

      systemd.tmpfiles.rules = [
        "Z /sys/class/powercap/intel-rapl:0/energy_uj 0444 root root - -"
      ];
    };
}
