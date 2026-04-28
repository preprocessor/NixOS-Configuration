{ inputs, ... }:
{
  ff.hjem = {
    url = "github:feel-co/hjem";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  w.default =
    {
      config,
      lib,
      constants,
      ...
    }:
    {
      imports = [
        inputs.hjem.nixosModules.default
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" constants.username ])
      ];

      hjem.clobberByDefault = true;

      # Sorce environment variables
      hj.files.".profile" = {
        executable = true;
        source = config.hj.environment.loadEnv;
      };
    };
}
