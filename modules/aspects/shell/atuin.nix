{ inputs, ... }:
{
  w.default =
    { pkgs, lib, ... }:
    let
      toml = pkgs.formats.toml { };
      wrappedAtuin = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.atuin;
        env = {
          ATUIN_CONFIG_DIR = pkgs.linkFarm "atuin-config" [
            {
              name = "config.toml";
              path = toml.generate "config.toml" {
                enter_accept = true;
                filter_mode = "session-preload";
                search_mode = "fuzzy";
              };
            }
          ];
        };
      };
    in
    {
      hj.packages = [ wrappedAtuin ];
      programs.fish.interactiveShellInit = "${lib.getExe wrappedAtuin} init fish | source";
    };
}
