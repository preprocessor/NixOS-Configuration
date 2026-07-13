{
  exo.core =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.nix-your-shell ];

      programs.fish.interactiveShellInit = ''
        if command -q nix-your-shell
          nix-your-shell fish | source
        end
      '';
    };
}
