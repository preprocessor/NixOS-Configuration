{
  tack.inputs.disko = {
    url = "gh:nix-community/disko";
    group = "nix";
  };

  modules.host.xyz = { inputs, ... }: {
    imports = [ inputs.disko.nixosModules.disko ];

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              bios = {
                priority = 1;
                name = "BIOS";
                size = "1M";
                type = "EF02";
              };
              ESP = {
                priority = 2;
                name = "ESP";
                start = "2M";
                end = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  # Subvolumes must set a mountpoint in order to be mounted,
                  # unless their parent is mounted
                  subvolumes = {
                    # Subvolume name is different from mountpoint
                    "/rootfs" = {
                      mountpoint = "/";
                    };
                    # Subvolume name is the same as the mountpoint
                    "/home" = {
                      mountOptions = [ "compress=zstd" ];
                      mountpoint = "/home";
                    };
                    # Parent is not mounted so the mountpoint must be set
                    "/nix" = {
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                      mountpoint = "/nix";
                    };
                    # # Subvolume for the swapfile
                    # "/swap" = {
                    #   mountpoint = "/.swapvol";
                    #   swap = {
                    #     swapfile.size = "20M";
                    #     swapfile2.size = "20M";
                    #     swapfile2.path = "rel-path";
                    #   };
                    # };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
