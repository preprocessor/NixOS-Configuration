{
  tack.inputs = {
    nixtopsy.url = "gh:amaanq/nixtopsy";
    nix-inspect.url = "gh:bluskript/nix-inspect";
  };

  exo.core =
    { pkgs, packages', ... }:
    {
      hj.packages =
        with pkgs;
        [
          nix-output-monitor
          nixfmt-rs
          nix-init
          nurl
        ]
        ++ (with packages'; [
          nixtopsy
          nix-inspect
        ]);
    };
}
