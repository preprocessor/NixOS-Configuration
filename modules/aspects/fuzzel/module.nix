{
  w.desktop =
    {
      pkgs,
      config,
      lib,
      wrappers,
      ...
    }:
    let
      sysCfg = config;

      fuzzelWrapped = wrappers.lib.wrapPackage (
        { config, lib, ... }:
        {
          inherit pkgs;
          package = pkgs.fuzzel;
          flagSeparator = "=";
          flags = {
            "--config" = config.constructFiles.generatedConfig.path;
          };
          constructFiles.generatedConfig = with sysCfg.custom.programs.fuzzel; {
            content = (lib.generators.toINI { } settings) + moreCfg;
            relPath = "${config.binName}.ini";
          };
        }
      );
    in
    {
      hj.packages = [ fuzzelWrapped ];
    };

  w.default =
    { lib, pkgs, ... }:
    {
      options.custom.programs.fuzzel = {
        settings = lib.mkOption {
          inherit (pkgs.formats.ini { }) type;
          default = { };
          description = ''
            Configuration of fuzzel.
            See {manpage}`fuzzel.ini(5)`
          '';
        };

        moreCfg = lib.mkOption {
          type = with lib.types; nullOr (either path lines);
          default = "";
          description = "Additional config lines.";
          example = lib.literalExpression "./fuzzel.ini";
        };
      };
    };
}
