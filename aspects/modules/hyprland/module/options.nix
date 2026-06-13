{
  w.default =
    { lib, pkgs, ... }:
    {
      options.wrappers.hyprland =
        let
          inherit (lib) mkEnableOption mkOption;
        in
        {
          enable = mkEnableOption { };

          package = lib.mkPackageOption pkgs "hyprland" { };

          withAutostart = mkEnableOption "autoStart" // {
            default = true;
          };
          withXwayland = mkEnableOption "XWayland" // {
            default = true;
          };
          withTermFileChooser = mkEnableOption "FileChooser" // {
            default = true;
          };
          withUWSM = mkEnableOption "UWSM" // {
            default = true;
            description = ''
              Launch Hyprland with the UWSM (Universal Wayland Session Manager) session manager.
              This has improved systemd support and is recommended for most users.
              This automatically starts appropriate targets like `graphical-session.target`,
              and `wayland-session@Hyprland.target`.

              ::: {.note}
              Some changes may need to be made to Hyprland configs depending on your setup, see
              [Hyprland wiki](https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm).
              :::
            '';
          };

          plugins = mkOption {
            type = with lib.types; listOf (either package path);
            default = [ ];
            description = ''
              List of Hyprland plugins to use. Can either be packages or
              absolute plugin paths.
            '';
          };

          startup = mkOption {
            type = with lib.types; listOf (either lines str);
            default = [ ];
            description = ''
              Autostart section of config, strings here will be executed with

              hl.on("hyprland.start", function()
                hl.exec_cmd(''${string})
              end)
            '';
          };

          lua =
            let
              apply = c: if builtins.isPath c then (builtins.readFile c) else c;
            in
            {
              pre = mkOption {
                default = "";
                description = "Lines to prepend to hyprland.lua, before the require block";
                type = with lib.types; either path lines;
                inherit apply;
              };

              post = mkOption {
                default = "";
                type = with lib.types; either path lines;
                description = "Lines to append to hyprland.lua, after the require block";
                inherit apply;
              };

              files = mkOption {
                type =
                  with lib.types;
                  attrsOf (
                    coercedTo (either path lines)
                      (content: {
                        inherit content;
                        autoLoad = true;
                      })
                      (submodule {
                        options = {
                          content = mkOption {
                            type = either path lines;
                            description = ''
                              Lua file content, set either by specifying a path to a Lua
                              file or by providing a multi-line Lua string.
                            '';
                          };
                          autoLoad = mkOption {
                            type = bool;
                            default = true;
                            description = ''
                              Whether to generate a `require(...)` call for this file in
                              {file}`$XDG_CONFIG_HOME/hypr/hyprland.lua`.
                            '';
                          };
                        };
                      })
                  );
                default = { };
                description = ''
                  Extra Lua files written under {file}`/nix/store/wrapper.../config/`.

                  Attribute names are used as Lua module names and converted to file
                  names with a {file}`.lua` suffix added when missing. For example,
                  `bindings` writes
                  {file}`/nix/store/wrapper.../config/bindings.lua`, while
                  `lib.helpers` writes {file}`$/nix/store/wrapper.../config/lib/helpers.lua`.

                  Files with {option}`autoLoad` enabled generate `require(...)` calls in
                  {file}`/nix/store/wrapper.../config/hyprland.lua` after adding the Hypr config
                  directory to Lua's `package.path`. Use {option}`autoLoad = false` for
                  helper modules that are imported by other Lua files.
                '';
                example = lib.literalExpression ''
                  {
                    "00-vars" = '\'
                      local M = {}
                      M.mainMod = "SUPER"
                      return M
                    '\';

                    "ui.bindings" = {
                      content = ./bindings.lua;
                      autoLoad = true;
                    };

                    "lib.helpers" = {
                      content = ./helpers.lua;
                      autoLoad = false;
                    };

                    "from-path.lua" = ./startup.lua;
                  }
                '';
              };
            };
        };
      _file = ./options.nix;
    };
}
