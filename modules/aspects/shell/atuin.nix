{ inputs, ... }:
{
  w.default =
    { pkgs, lib, ... }:
    let
      toml = pkgs.formats.toml { };
    in
    {
      nixpkgs.overlays = [
        (_: prev: {
          atuin = inputs.wrappers.lib.wrapPackage (
            { config, ... }:
            {
              pkgs = prev;
              package = prev.atuin;
              env.ATUIN_CONFIG_DIR = dirOf config.constructFiles.atuin-config.path;
              constructFiles.atuin-config = {
                relPath = "atuin-config/config.toml";
                content = builtins.readFile (
                  toml.generate "config.toml" {
                    enter_accept = true;
                    filter_mode = "session-preload";
                    search_mode = "fuzzy";
                  }
                );
              };
            }
          );
        })
      ];

      hj.packages = [ pkgs.atuin ];

      programs.fish.interactiveShellInit = "${lib.getExe pkgs.atuin} init fish | source";
    };
}
