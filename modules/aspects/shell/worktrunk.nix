{ lib, ... }:
{
  flake.modules.nixos.default =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.worktrunk ];
      programs.fish.interactiveShellInit = "${lib.getExe pkgs.worktrunk} config shell init fish | source";
    };
}
