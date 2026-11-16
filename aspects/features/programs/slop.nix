{
  modules.host.ramiel = { wrapPackage, pkgs, ... }: {
    hj.packages = with pkgs; [
      worktrunk
      opencode

      (wrapPackage {
        package = omp;
        runtimePackages = [ python3 ];
      })
    ];
  };
}
