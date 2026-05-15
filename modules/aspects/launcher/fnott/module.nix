{
  w.default =
    {
      birdee,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.wrappers.fnott;
      inherit (lib) mkOption types;
    in
    {
      options.wrappers.fnott = {
        enable = lib.mkEnableOption { };

        settings = mkOption {
          type = with types; attrsOf anything;
          default = { };
          description = ''
            Configuration of ${config.binName}.
            See {manpage}`fnott.ini(5)`
          '';
        };

        moreCfg = mkOption {
          type = with types; nullOr (either path lines);
          default = "";
          description = "Additional config lines.";
          example = lib.literalExpression "./fnott.ini";
        };

        package = mkOption {
          type = types.package;
          description = "The ${config.binName} package to use.";
          default = birdee.lib.wrapPackage (
            { config, lib, ... }:
            {
              inherit pkgs;
              package = pkgs.fnott;
              flags = {
                "--config" = config.constructFiles.generatedConfig.path;
              };
              constructFiles.generatedConfig = {
                relPath = "fnott.ini";
                content = (cfg.settings |> lib.generators.toINIWithGlobalSection { }) + cfg.moreCfg;
              };
            }
          );
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = with pkgs; [
          libnotify
          cfg.package
        ];
      };
    };
}
