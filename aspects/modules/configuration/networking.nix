{
  w.default = {
    # Enable networking
    networking.networkmanager.enable = true;

    boot = {
      kernelModules = [ "tcp_bbr" ];
      kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
      kernel.sysctl."net.core.default_qdisc" = "fq"; # or "cake" for newer kernels
    };
  };
}
