{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        nix-output-monitor
        nix-init
        nixfmt-rs
        nurl
      ];
    };
}
