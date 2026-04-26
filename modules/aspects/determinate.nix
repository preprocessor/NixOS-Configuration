{ inputs, ... }:
{
  ff.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

  w.default = {
    imports = [ inputs.determinate.nixosModules.default ]; # Load the Determinate module

    nix.settings = {
      extra-substituters = [ "https://install.determinate.systems" ];
      extra-trusted-public-keys = [ "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=" ];

      extra-experimental-features = [ "build-time-fetch-tree" ];
    };
  };
}
