{
  exo.mods.desktop = {
    my.xdg.desktopEntries."nixos-manual".noDisplay = true;
  };

  exo.skeleton =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkOption types;

      desktopEntry = {
        options = {
          type = mkOption {
            description = "The type of the desktop entry.";
            default = "Application";
            type = types.enum [
              "Application"
              "Link"
              "Directory"
            ];
          };
          exec = mkOption {
            description = "Program to execute, possibly with arguments.";
            type = types.nullOr types.str;
          };
          icon = mkOption {
            description = "Icon to display in file manager, menus, etc.";
            type = with types; nullOr (either str path);
          };
          comment = mkOption {
            description = "Tooltip for the entry.";
            type = types.nullOr types.str;
          };
          terminal = mkOption {
            description = "Whether the program runs in a terminal window.";
            type = types.nullOr types.bool;
            default = false;
          };
          name = mkOption {
            description = "Specific name of the application.";
            default = "";
            type = types.str;
          };
          genericName = mkOption {
            description = "Generic name of the application.";
            type = types.nullOr types.str;
          };
          mimeType = mkOption {
            description = "The MIME type(s) supported by this application.";
            type = types.nullOr (types.listOf types.str);
          };
          categories = mkOption {
            description = "Categories in which the entry should be shown in a menu.";
            type = types.nullOr (types.listOf types.str);
          };
          startupNotify = mkOption {
            description = "If true, it is KNOWN that the app will send a remove message.";
            type = types.nullOr types.bool;
          };
          noDisplay = mkOption {
            description = "Means this application exists, but don't display it in the menus.";
            type = types.nullOr types.bool;
          };
          prefersNonDefaultGPU = mkOption {
            description = "If true, the application prefers to be run on a more powerful discrete GPU.";
            type = types.nullOr types.bool;
          };
          settings = mkOption {
            type = types.attrsOf types.str;
            description = "Extra key-value pairs to add to the `[Desktop Entry]` section.";
            default = { };
          };
          actions = mkOption {
            type = types.attrsOf (
              types.submodule (
                { name, ... }:
                {
                  options = {
                    name = mkOption {
                      type = types.str;
                      default = name;
                      description = "Name of the action.";
                    };
                    exec = mkOption {
                      type = types.nullOr types.str;
                      description = "Program to execute.";
                    };
                    icon = mkOption {
                      type = with types; nullOr (either str path);
                      description = "Icon to display.";
                    };
                  };
                }
              )
            );
            default = { };
            description = "The set of actions made available to application launchers.";
          };
        };
      };

      makeFile =
        name: cfg:
        pkgs.makeDesktopItem {
          inherit name;
          inherit (cfg)
            type
            exec
            icon
            comment
            terminal
            genericName
            startupNotify
            noDisplay
            prefersNonDefaultGPU
            actions
            ;
          desktopName = cfg.name;
          mimeTypes = lib.optionals (!isNull cfg.mimeType) cfg.mimeType;
          categories = lib.optionals (!isNull cfg.categories) cfg.categories;
          extraConfig = cfg.settings;
        };
    in
    {
      config =
        let
          tui = config.my.xdg.desktopTuiEntries;
        in
        {
          environment.systemPackages =
            config.my.xdg.desktopEntries |> lib.mapAttrsToList makeFile |> map lib.hiPrio;

          hj.packages = config.my.xdg.desktopEntries |> lib.mapAttrsToList makeFile |> map lib.hiPrio;

          my.xdg.desktopEntries =
            tui
            |> lib.mapAttrs' (
              name: value: {
                name = (name |> lib.replaceStrings [ " " ] [ "_" ]);
                value = {
                  inherit name;
                  icon = "kitty";
                  exec = ''hyprctl dispatch "hl.dsp.exec_cmd('kitty --class ${name} -e ${lib.getExe value.package}', {size = {${toString value.width}, ${toString value.height}}, float = true, center = true})"'';
                };
              }
            );
        };

      options.my.xdg = {
        desktopEntries = mkOption {
          description = "Custom Desktop Entries";
          default = { };
          type = types.attrsOf (types.submodule desktopEntry);
        };

        desktopTuiEntries = lib.mkOption {
          description = "Custom Desktop Entries";
          default = { };
          type = types.attrsOf (
            types.submodule {
              options = {
                package = lib.mkOption {
                  type = types.package;
                };

                width = lib.mkOption {
                  type = types.number;
                };

                height = lib.mkOption {
                  type = types.number;
                };
              };
            }
          );
        };
      };
    };
}
