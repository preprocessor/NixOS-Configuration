{
  w.default =
    { pkgs, lib, ... }:
    {
      # programs.fish.interactiveShellInit = ''
      #   ${lib.getExe pkgs.nix-your-shell} --nom fish | source
      # '';
    };
}
