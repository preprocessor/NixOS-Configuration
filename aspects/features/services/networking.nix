{
  modules.core = { lib, ... }: {
    # Enable NetworkManager
    networking.networkmanager.enable = lib.mkDefault true;

    boot = {
      kernelModules = [ "tcp_bbr" ];
      kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
      kernel.sysctl."net.core.default_qdisc" = "cake";
    };

    networking.nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
  };

  modules.host.xyz = {
    networking.networkmanager.enable = true;
    networking = {
      defaultGateway = "147.93.176.1";
      interfaces."eth0".useDHCP = false;
      useDHCP = false;

      defaultGateway6 = {
        address = "fe80::1";
        interface = "eth0";
      };

      interfaces."eth0".ipv4.addresses = [
        {
          address = "147.93.189.239";
          prefixLength = 20;
        }
      ];

      interfaces."eth0".ipv6.addresses = [
        {
          address = "2605:a144:2376:929::1";
          prefixLength = 64;
        }
      ];
    };
  };
}
