{
  w.default =
    {
      pkgs,
      lib,
      birdee,
      ...
    }:
    let
      toml = pkgs.formats.toml { };
    in
    {
      nixpkgs.overlays = [
        (_: prev: {
          atuin = birdee.lib.wrapPackage (
            { config, ... }:
            {
              pkgs = prev;
              package = prev.atuin;
              env.ATUIN_CONFIG_DIR = dirOf config.constructFiles.atuin-config.path;
              constructFiles.atuin-config = {
                relPath = "atuin-config/config.toml";
                builder = ''
                  install -m655 -DT "${
                    toml.generate "config.toml" {
                      enter_accept = true;
                      filter_mode = "session-preload";
                      search_mode = "fuzzy";
                    }
                  }" "$2"
                '';
              };
            }
          );
        })
      ];

      hj.packages = [ pkgs.atuin ];

      programs.fish.interactiveShellInit = "${lib.getExe pkgs.atuin} init fish | source";
    };
}
