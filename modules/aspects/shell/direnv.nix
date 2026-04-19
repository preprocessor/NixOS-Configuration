{ inputs, ... }:
{
  ff.direnv-instant = {
    url = "github:Mic92/direnv-instant";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  w.default =
    { lib, pkgs, ... }:
    let
      direnv-instant = inputs.direnv-instant.packages.${pkgs.sys}.direnv-instant;
      package = (
        pkgs.runCommand "direnv-instant"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ];
            inherit (direnv-instant) meta;
          }
          /* bash */ ''
            mkdir -p $out/bin
            makeWrapper ${lib.getExe direnv-instant} $out/bin/direnv-instant \
              --set-default DIRENV_INSTANT_USE_CACHE 1
          ''
      );

      direnv-instant-overlay = final: prev: {
        direnv-instant = package;
      };
    in
    {
      nixpkgs.overlays = [ direnv-instant-overlay ];

      environment.systemPackages = [ pkgs.direnv-instant ];

      programs.direnv = {
        enable = true;
        silent = true;
        enableFishIntegration = true;
        nix-direnv.enable = true;
      };

      programs.fish.interactiveShellInit = lib.mkAfter ''
        ${lib.getExe pkgs.direnv-instant} hook fish | source
      '';
    };
}
