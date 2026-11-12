{
  flake.hjemModules.bat =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.bat;
    in
    {
      options.my.bat = {
        enable = lib.mkEnableOption { };

        package = lib.mkPackageOption pkgs "bat" { };

        syntaxes = lib.mkOption {
          type = with lib.types; attrsOf (either str path);
          default = { };
        };

        themes = lib.mkOption {
          type = with lib.types; attrsOf (either str path);
          default = { };
        };

        config = lib.mkOption {
          default = { };
          type =
            with lib.types;
            attrsOf (oneOf [
              number
              str
              path
            ]);
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        programs.fish.interactiveShellInit = /* fish */ ''
          ${lib.getExe' cfg.package "batman"} --export-env | source
          eval (${lib.getExe' cfg.package "batpipe"})
        '';
      };
    };

}
