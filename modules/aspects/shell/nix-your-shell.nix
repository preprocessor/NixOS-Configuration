{
  w.default =
    { pkgs, lib, ... }:
    {
      programs.fish.interactiveShellInit = ''
        if command -q nix-your-shell
          ${lib.getExe pkgs.nix-your-shell} --nom fish | source | source
        end
      '';
    };
}
