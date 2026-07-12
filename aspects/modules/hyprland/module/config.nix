{
  w.default =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.hyprland;

      hasStartup = cfg.startup != [ ];
      hasPlugins = cfg.plugins != [ ];

      # filename.lua -> filename
      requireName = name: lib.removeSuffix ".lua" name;

      # folder.filename.lua -> folder/filename.lua
      luaFileName = name: builtins.replaceStrings [ "." ] [ "/" ] (requireName name) + ".lua";

      autoLoadFiles = lib.filterAttrs (_: file: file.autoLoad) cfg.lua.files;

      pluginPath =
        entry: if lib.types.package.check entry then "${entry}/lib/lib${entry.pname}.so" else entry;

      startupSection = lib.concatStrings [
        (lib.optionalString (hasPlugins || hasStartup) ''
          hl.on("hyprland.start", function()
        '')

        (lib.optionalString hasPlugins ''
            -- my.hyprland.plugins
          ${cfg.plugins |> map (entry: "  hyprctl plugin load ${pluginPath entry}")}
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
