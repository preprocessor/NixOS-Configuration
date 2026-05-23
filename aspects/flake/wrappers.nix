{
  ff.birdee = {
    url = "github:BirdeeHub/nix-wrapper-modules";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  w.default =
    { config, lib, ... }:
    let
      inherit (lib) mkOption types;
    in
    {
      options.wrappers = mkOption {
        default = { };
        type = types.submodule {
          freeformType = types.attrs;
          options = {
            settings = lib.mkOption {
              default = { };
              type = types.submodule {
                freeformType = types.attrs;
              };
            };

            package = lib.mkOption {
              default = { };
              type = lib.types.attrs;
            };
          };
        };
      };

      _file = ./wrappers.nix;
    };
}
