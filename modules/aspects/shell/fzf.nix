{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.fzf ];

      programs.fish.interactiveShellInit = /* fish */ ''
        source ${pkgs.fzf}/share/fzf/key-bindings.fish && fzf_key_bindings
      '';
    };
}
