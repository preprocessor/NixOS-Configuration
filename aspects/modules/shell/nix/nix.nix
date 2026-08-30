{
  tack.inputs.nixtopsy.url = "gh:amaanq/nixtopsy";

  exo.core =
    { pkgs, packages', ... }:
    {
      hj.packages =
        with pkgs;
        [
          nix-output-monitor
          nix-inspect
          nixfmt-rs
          nix-init
          nurl
        ]
        ++ (with packages'; [
          nixtopsy
        ]);
    };
}
