{
  tack.inputs.nixtopsy = {
    url = "gh:amaanq/nixtopsy";
    group = "nix";
  };

  modules.core = { pkgs, packages', ... }: {
    hj.packages =
      with pkgs;
      [
        nix-output-monitor
        nix-inspect
        nixfmt-rs
        nurl
      ]
      ++ [ packages'.nixtopsy ];
  };
}
