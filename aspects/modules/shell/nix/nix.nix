{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        nix-output-monitor
        nixfmt-rs
        nix-tree
        nix-init
        nurl
      ];
    };
}
