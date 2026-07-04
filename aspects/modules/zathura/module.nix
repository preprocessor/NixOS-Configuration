{
  w.default =
    {
      config,
      birdee,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.custom.programs.zathura;
    in
    {
      options.custom.programs.zathura = {
        enable = lib.mkEnableOption ''
          Zathura, a highly customizable and functional document viewer
          focused on keyboard interaction'';

        options = lib.mkOption {
          default = { };
          type =
            with lib.types;
            attrsOf (oneOf [
              str
              bool
              int
              float
            ]);
          description = ''
            Add {option}`:set` command options to zathura and make
            them permanent. See
            {manpage}`zathurarc(5)`
            for the full list of options.
          '';
          example = {
            default-bg = "#000000";
            default-fg = "#FFFFFF";
          };
        };

        mappings = lib.mkOption {
          default = { };
          type = with lib.types; attrsOf str;
          description = ''
            Add {option}`:map` mappings to zathura and make
            them permanent. See
            {manpage}`zathurarc(5)`
            for the full list of possible mappings.

            You can create a mode-specific mapping by specifying the mode before the key:
            `"[normal] <C-b>" = "scroll left";`
          '';
          example = {
            D = "toggle_page_mode";
            "<Right>" = "navigate next";
            "[fullscreen] <C-i>" = "zoom in";
          };
        };

        moreCfg = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Additional commands for zathura that will be added to the
            {file}`zathurarc` file.
          '';
        };

        package = lib.mkOption {
          default = birdee.lib.wrapPackage (
            { config, ... }:
            {
              inherit pkgs;
              package = pkgs.zathura;
              flags = {
                "--config-dir" = config.constructFiles.generatedConfig.path;
              };
              constructFiles.generatedConfig = {
                relPath = "zathura/zathurarc";
                content =
                  lib.concatStringsSep "\n" (
                    lib.optional (cfg.moreCfg != "") cfg.moreCfg
                    ++ lib.mapAttrsToList lib.formatLine cfg.options
                    ++ lib.mapAttrsToList lib.formatMapLine cfg.mappings
                  )
                  + "\n";
              };
            }
          );
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];
      };
    };
}
