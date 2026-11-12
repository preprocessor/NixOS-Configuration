{
  flake.hjemModules.atuin =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.atuin;
      toml = pkgs.formats.toml { };
    in
    {
      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        programs.fish.interactiveShellInit = "${lib.getExe cfg.package} init fish | source";
      };

      options.my.atuin = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "atuin" { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into atuin's yaml config";
        };
      };
    };
}
