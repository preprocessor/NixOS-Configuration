{
  w.default =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.my.delta;
    in
    {
      options.my.delta = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          type = lib.types.toml;
          default = { };
          description = "Options to go into delta's config section in gitconfig";
        };

        package = lib.mkPackageOption pkgs "delta" { };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];

        programs.git.config.delta = cfg.settings;
      };

      _file = ./delta.nix;

    };
}
