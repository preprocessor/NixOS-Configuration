{
  w.default =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.wrappers.hyprland;

      hasStartup = cfg.startup != [ ];
      hasPlugins = cfg.plugins != [ ];

      toLua = lib.generators.toLua { };

      requireName = name: lib.removeSuffix ".lua" name;

      luaFileName = name: builtins.replaceStrings [ "." ] [ "/" ] (requireName name) + ".lua";

      autoLoadFiles = lib.filterAttrs (_: file: file.autoLoad) cfg.lua.files;

      pluginPath =
        entry: if lib.types.package.check entry then "${entry}/lib/lib${entry.pname}.so" else entry;

      startupSection = lib.concatStrings [
        (lib.optionalString (hasPlugins || hasStartup) ''
          hl.on("hyprland.start", function()
        '')

        (lib.optionalString hasPlugins ''
          -- wrappers.hyprland.plugins
          ${cfg.plugins |> map (entry: "hyprctl plugin load ${pluginPath entry}")}
        '')

        (lib.optionalString hasStartup ''
          -- wrappers.hyprland.startup
          ${cfg.startup |> lib.concatMapStrings (command: "  hl.exec_cmd(${toLua command})\n")}
        '')

        (lib.optionalString (hasPlugins || hasStartup) ''
          end)
        '')
      ];
    in
    {
      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            hj.xdg.config.files = {
              "hypr/hyprland.lua".text = lib.concatStrings [
                (lib.optionalString (cfg.lua.pre != "") ''
                  -- wrappers.hyprland.lua.pre
                  ${cfg.lua.pre}

                '')

                (lib.optionalString (hasStartup || hasPlugins) startupSection)

                (lib.optionalString (autoLoadFiles != { }) ''
                  -- wrappers.hyprland.lua.files {autoLoad = true}
                  ${
                    autoLoadFiles |> lib.mapAttrsToList (name: _: ''require("${requireName name}")'') |> lib.concatLines
                  }

                '')

                (lib.optionalString (cfg.lua.post != "") ''
                  -- wrappers.hyprland.lua.post
                  ${cfg.lua.post}

                '')

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
                  name = "hypr/${luaFileName fileName}";
                  value = {
                    text = file.content;
                  };
                }
              );
          }
          {
            hj.packages = with pkgs; [
              hyprshutdown
              wayfreeze
              slurp
              grim

              cfg.package
            ];

            # Allows lua stub file to be accessed from /run/current-system/sw/share/hypr
            environment.pathsToLink = [ "/share/hypr" ];

            security.wrappers.Hyprland = {
              owner = "root";
              group = "root";
              capabilities = "cap_sys_nice+ep";
              source = lib.getExe cfg.package;
            };

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
            programs.bash.interactiveShellInit =
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
