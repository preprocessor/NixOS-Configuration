{
  exo.skeleton =
    {
      config,
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
                  value = {
                    text = file.content;
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

              mkFlags = lib.mapAttrsToList (name: value: "name = " + lib.boolToString value) |> lib.join ", ";

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
              wayfreeze
              slurp
              grim

              cfg.package
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

      _file = ./config.nix;
    };
}
