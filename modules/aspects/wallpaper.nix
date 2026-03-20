{ inputs, ... }:
{
  flake-file.inputs.awww.url = "git+https://codeberg.org/LGFae/awww";

  flake.modules.homeManager.wayland =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
        pkgs.waypaper
      ];
    };
}
