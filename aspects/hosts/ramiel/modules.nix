{
  withSystem,
  inputs,
  config,
  ...
}:
{
  flake.nixosConfigurations.ramiel = withSystem "x86_64-linux" (
    {
      self',
      inputs',
      packages',
      ...
    }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self' inputs' packages';
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
