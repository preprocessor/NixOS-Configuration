{
  withSystem,
  inputs,
  config,
  ...
}:
{
  flake.nixosConfigurations.ramiel = withSystem "x86_64-linux" (
    { self', inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self' inputs';
        inherit (inputs) birdee;
      };
      modules = with config.w; [
        default
        gaming
        ramiel
        desktop
        wyspr-theme
        base16
        shell
      ];
    }
  );
}
