{
  exo.mods.desktop.my.zathura = {
    enable = true;
  };

  exo.skeleton =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.zathura;
    in
    {
      options.my.zathura = {
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

        package = lib.mkOption {
          default = wrapPackage (
            { files, ... }:
            {
              package = pkgs.zathura;
              args = [ "--config-dir ${files.config.dir}" ];
              files.config = {
                relPath = "config/zathurarc";
                file =
                  lib.concatLines (
                    lib.mapAttrsToList lib.formatLine cfg.options ++ lib.mapAttrsToList lib.formatMapLine cfg.mappings
                  )
                  + "\n";
              };
            }
          );
        };
      };

      config = lib.mkIf cfg.enable {
        hj.packages = [ cfg.package ];

        my.hyprland.windowrules.zathura = [
          {
            name = "float-zathura";
            match.class = "^org.pwmt.zathura$";
            rules.float = true;
          }
        ];
      };

      _file = "zathura_module.nix";
    };
}
