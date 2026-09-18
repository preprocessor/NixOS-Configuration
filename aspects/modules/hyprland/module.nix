{
  tack.inputs.hyprland.url = "gh:hyprwm/Hyprland";

  perSystem =
    { pkgs, ... }:
    {
      remotePackages = {
        hyprland-bundle = pkgs.symlinkJoin {
          name = "hyprland-bundle";
          paths = with pkgs; [
            xdg-desktop-portal-hyprland
            scrolloverview
            hyprcapture
            hyprland
          ];
        };
      };
    };

  exo.skeleton =
    {
      config,
      inputs,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.hyprland;

      hasStartup = cfg.startup != [ ];
      hasPlugins = cfg.plugins != { };

      # filename.lua -> filename
      requireName = name: lib.removeSuffix ".lua" name;

      # folder.filename.lua -> folder/filename.lua
      luaFileName = name: lib.replaceStrings [ "." ] [ "/" ] (requireName name) + ".lua";

      autoLoadFiles = cfg.lua.files |> lib.filterAttrs (_: file: file.autoLoad);

      pluginPath =
        entry: if lib.types.package.check entry then "${entry}/lib/lib${entry.pname}.so" else entry;

      startupSection = lib.concatStrings [
        (lib.optionalString (hasPlugins || hasStartup) ''
          hl.on("hyprland.start", function()
        '')

        (lib.optionalString hasPlugins ''
            -- my.hyprland.plugins
          ${
            cfg.plugins
            |> lib.mapAttrsToList (_: value: "  hl.exec_cmd(\"hyprctl plugin load ${pluginPath value}\")")
            |> lib.concatLines
          }
        '')

        (lib.optionalString hasStartup ''
            -- my.hyprland.startup
          ${cfg.startup |> lib.concatMapStrings (command: "  ${command}\n")}'')

        (lib.optionalString (hasPlugins || hasStartup) ''
          end)
        '')
      ];
    in
    {
      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            utils.hyprSpawn = width: height: class: app: ''
              hyprctl dispatch "hl.dsp.exec_cmd('kitty --class ${class} -e ${app}', {size = {${toString width}, ${toString height}}, float = true, center = true})"
            '';

            hj.xdg.config.files = {
              "hypr/hyprland.lua".text = lib.concatStrings [
                (lib.optionalString (cfg.lua.pre != "") ''
                  -- my.hyprland.lua.pre
                  ${cfg.lua.pre}

                '')

                (lib.optionalString (hasStartup || hasPlugins) startupSection)

                (lib.optionalString (autoLoadFiles != { }) /* lua */ ''

                  local load = function(path)
                    require("files." .. path)
                  end

                  -- my.hyprland.lua.files."...".autoLoad = true
                  ${autoLoadFiles |> lib.mapAttrsToList (name: _: ''load("${requireName name}")'') |> lib.concatLines}
                '')

                (lib.optionalString (cfg.lua.post != "") ''
                  -- my.hyprland.lua.post
                  ${cfg.lua.post}

                '')

                # lua
                ''
                  -- dynamic code
                  if utils.does_file_exist("${config.hj.xdg.config.directory}/hypr/dynamic.lua") then
                    require("dynamic")
                  end
                ''
              ];

              "hypr/.luarc.json".text = /* json */ ''
                {
                  "workspace": {
                    "library": [
                      "${cfg.package}/share/hypr/stubs"
                    ]
                  }
                }
              '';

              "hypr/xdph.conf".text = /* kdl */ ''
                screencopy {
                    max_fps = 60
                    allow_token_by_default = true
                }
              '';
            };
          }
          {
            hj.xdg.config.files =
              cfg.lua.files
              |> lib.mapAttrs' (
                fileName: file: {
                  name = "hypr/files/${luaFileName fileName}";
                  value.source = pkgs.writeTextFile {
                    name = "${fileName}.lua";
                    text = file.content;
                    checkPhase = /* bash */ ''
                      if !(${pkgs.lua}/bin/luac -p $out); then
                        echo -e "\nLua Error: ${fileName}.lua has incorrect syntax\n"
                        exit 1
                      fi
                    '';
                  };
                }
              );
          }
          (
            let
              windowrules = cfg.windowrules;

              generateRules =
                indent:
                lib.mapAttrsToList (
                  name: value:
                  let
                    stringify =
                      s:
                      if (lib.isBool s) then
                        lib.boolToString s
                      else if (lib.isString s) then
                        ''"${s}"''
                      else
                        toString s;

                    value' =
                      if (lib.isList value) then
                        # return list as lua table
                        "{ ${lib.join ", " (value |> map stringify)} }"
                      else
                        stringify value;
                  in
                  indent + "${name} = ${value'},"
                );
            in
            (lib.mkIf (windowrules != { }) {
              my.hyprland.lua.files =
                windowrules
                |> lib.mapAttrs' (
                  fileName: windowrulesList: {
                    name = "window_rules.${fileName}";
                    value.content =
                      windowrulesList
                      |> lib.concatMapStringsSep "\n\n" (
                        rule:
                        lib.concatLines (
                          [
                            "hl.window_rule({"
                            (lib.optional (rule.name != null) "  name = \"${rule.name}\",")
                            "  match = {"
                            (generateRules "    " rule.match)
                            "  },"
                            (generateRules "  " rule.rules)
                            "})"
                          ]
                          |> lib.flatten
                        )
                      );
                  }
                );
            })
          )
          (
            let
              binds = cfg.keybinds;

              mkFlags = lib.mapAttrsToList (_: value: "name = " + lib.boolToString value) |> lib.join ", ";

              mkBind =
                name: value:
                let
                  value' =
                    if !(lib.isString value) then
                      "${value.dispatcher}${lib.optionalString (value.flags != null) ", { ${mkFlags value.flags} }"}"
                    else
                      value;
                in
                ''hl.bind("${name}", ${value'})'';

            in
            (lib.mkIf (binds != { }) {
              my.hyprland.lua.files =
                binds
                |> lib.mapAttrs' (
                  fileName: binds: {
                    name = "keybinds.${fileName}";
                    value.content = binds |> lib.mapAttrsToList mkBind |> lib.concatLines;
                  }
                );
            })

          )
          {
            hj.packages = with pkgs; [
              hyprshutdown
              cfg.package
            ];

            nixpkgs.overlays = [
              inputs.hyprland.overlays.hyprland-packages
              inputs.hyprland.overlays.default
            ];

            nix.settings = {
              substituters = [ "https://hyprland.cachix.org" ];
              trusted-substituters = [ "https://hyprland.cachix.org" ];
              trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
              # Required so non-root users are allowed to use the above substituter/keys.
              # Use @wheel for all sudo users, or list your username explicitly.
              trusted-users = [
                "root"
                "@wheel"
              ];
            };

            # Allows lua stub file to be accessed from /run/current-system/sw/share/hypr
            environment.pathsToLink = [ "/share/hypr" ];

            xdg.portal = {
              enable = true;
              extraPortals = [
                pkgs.xdg-desktop-portal-hyprland
                pkgs.xdg-desktop-portal-gtk
              ];
              wlr.enable = false;
              configPackages = lib.mkDefault [ cfg.package ];
            };

            systemd.user.settings.Manager = {
              DefaultEnvironment = "PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH";
            };

            programs.xwayland.enable = cfg.withXwayland;
            programs.uwsm.enable = cfg.withUWSM;
          }

          (lib.mkIf cfg.withAutostart {
            programs.bash.loginShellInit =
              let
                session =
                  if cfg.withUWSM then # bash
                    "exec uwsm start hyprland-uwsm.desktop"
                  else
                    lib.getExe' cfg.package "start-hyprland";
              in
              lib.mkOrder 0 /* bash */ ''
                # Auto start wayland session on tty1
                if [[ $(tty) == '/dev/tty1' ]]; then
                  ${session}
                fi
              '';
          })

          (lib.mkIf cfg.withTermFileChooser {
            xdg.portal.config.hyprland = {
              default = lib.mkForce [
                "hyprland"
                "gtk"
              ];
              "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "termfilechooser" ];
              "org.freedesktop.impl.portal.Secret" = lib.mkForce [ "gnome-keyring" ];
              "org.freedesktop.impl.portal.Chooser" = lib.mkForce [ "none" ];
            };
          })
        ]
      );

      options.my.hyprland =
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
            type = with lib.types; attrsOf (either package path);
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

          windowrules = mkOption {
            default = { };
            type =
              with lib.types;
              attrsOf (
                listOf (submodule {
                  options = {
                    name = mkOption {
                      type = nullOr str;
                    };
                    match = mkOption {
                      type = attrsOf unspecified;
                    };
                    rules = mkOption {
                      type = attrsOf unspecified;
                    };
                  };
                })
              );
          };

          keybinds = mkOption {
            default = { };
            type =
              with lib.types;
              attrsOf (
                attrsOf (
                  either str (submodule {
                    options = {
                      keys = mkOption { type = str; };
                      dispatcher = mkOption { type = str; };
                      flags = mkOption {
                        type = nullOr (attrsOf bool);
                      };
                    };
                  })
                )
              );
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
