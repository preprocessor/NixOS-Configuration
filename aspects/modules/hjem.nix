{ inputs, ... }:
{
  tack.hjem.url = "gh:feel-co/hjem";

  exo.core =
    {
      config,
      lib,
      constants,
      inputs',
      ...
    }:
    {
      imports = [
        inputs.hjem.nixosModules.default
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" constants.username ])
      ];

      nixpkgs.overlays = [ (_: _: { inherit (inputs'.hjem.packages) smfh; }) ];

      hjem.clobberByDefault = true;

      hj = {
        enable = true;

        user = constants.username;
        directory = constants.homedir;

        # Sorce environment variables
        files.".profile" = {
          executable = true;
          source = config.hj.environment.loadEnv;
        };
      };
    };
}
