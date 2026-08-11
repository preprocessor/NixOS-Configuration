{ inputs, ... }:
{
  tack.inputs.hjem.url = "gh:feel-co/hjem";

  exo.core =
    {
      constants,
      packages',
      config,
      lib,
      ...
    }:
    {
      imports = [
        inputs.hjem.nixosModules.default
        (lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" constants.username ])
      ];

      config = lib.mkMerge [
        {
          nixpkgs.overlays = [ (_: _: { inherit (packages'.hjem) smfh; }) ];

          hjem.clobberByDefault = true;

          hj = {
            enable = true;

            user = constants.username;
            directory = constants.homedir;

            # Sorce environment variables into ~/.profile
            files.".profile" = {
              executable = true;
              source = config.hj.environment.loadEnv;
            };
          };
        }

        (lib.mkIf (config.programs.fish.enable) {
          hj.xdg.config.files."fish/config.fish".text = ''
            if not test -n "$__HJEM_ENV_INIT"
              source "${config.hj.environment.loadEnv}"
              set __HJEM_ENV_INIT 1
            end
          '';
        })

        (lib.mkIf (config.programs.bash.enable) {
          programs.bash.loginShellInit = "source ${config.hj.environment.loadEnv}";
        })
      ];
    };
}
