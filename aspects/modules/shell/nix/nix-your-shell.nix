{
  w.default =
    { pkgs, lib, ... }:
    {
      hj.packages = [ pkgs.nix-your-shell ];

      programs.fish.interactiveShellInit = ''
        if command -q nix-your-shell
          nix-your-shell fish | source
        end
      '';
    };
}
