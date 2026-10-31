{
  exo.host.ramiel = { pkgs, ... }: {
    hj.packages = with pkgs; [
      worktrunk
      opencode
    ];
  };
}
