{ inputs, ... }:
{
  tack.hjem.url = "gh:feel-co/hjem";

  w.default =
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

      # Sorce environment variables
      hj.files.".profile" = {
        executable = true;
        source = config.hj.environment.loadEnv;
      };
    };
}
