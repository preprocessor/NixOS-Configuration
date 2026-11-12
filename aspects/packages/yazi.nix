{
  tack.inputs.sxyazi = {
    url = "gh:sxyazi/yazi";
    group = "yazi";
  };

  perSystem = { packages', ... }: { remotePackages.yazi = packages'.sxyazi; };
}
