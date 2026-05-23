# Sources:
# https://github.com/iynaix/dotfiles/blob/7cfd3aec29feec3807206591260e594ad28094f9/modules/gui/niri/default.nix
# https://github.com/onelocked/NixOS/blob/master/modules/nixos/desktop/niri/niri.nix
{
  w.default =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      options.wrappers = {
        niri = {
          settings = lib.mkOption {
            type = lib.types.submodule {
              freeformType = lib.types.attrs;
              options = {
                binds = lib.mkOption {
                  default = { };
                  type = lib.types.attrs;
                };
                layout = lib.mkOption {
                  default = { };
                  type = lib.types.attrs;
                };
                spawn-at-startup = lib.mkOption {
                  default = [ ];
                  type = lib.types.listOf (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
                };
                window-rules = lib.mkOption {
                  default = [ ];
                  type = lib.types.listOf lib.types.attrs;
                };
                layer-rules = lib.mkOption {
                  default = [ ];
                  type = lib.types.listOf lib.types.attrs;
                };
                workspaces = lib.mkOption {
                  default = { };
                  type = lib.types.attrsOf (lib.types.nullOr lib.types.anything);
                };
                outputs = lib.mkOption {
                  default = { };
                  type = lib.types.attrs;
                };
                # change to lines to allow merging
                extraConfig = lib.mkOption {
                  type = lib.types.lines;
                  default = "";
                  description = "Additional configuration lines.";
                };
              };
            };
            description = "Niri settings, see https://github.com/Lassulus/wrappers/blob/main/modules/niri/module.nix for available options";
          };
        };
      };

      config = lib.mkIf config.programs.niri.enable {
        programs.niri.useNautilus = false;

        programs.uwsm.waylandCompositors.niri = {
          prettyName = "niri";
          comment = "Niri compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/niri";
          # [NOTE] "/run/current-system/sw/bin/niri" is preferred to "lib.getExe pkgs.niri" avoid version mismatch
          extraArgs = [ "--session" ];
        };

        xdg.portal = {
          config = {
            niri = {
              "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "termfilechooser" ];
              default = lib.mkForce [ "gnome" ];
              "org.freedesktop.impl.portal.Secret" = lib.mkForce [ "gnome-keyring" ];
              "org.freedesktop.impl.portal.Chooser" = lib.mkForce [ "none" ];
            };
          };
        };
        # restart niri with new settings on rebuild
        system.userActivationScripts = {
          niri-reload-config = {
            text = lib.getExe (
              pkgs.writeShellApplication (
                let
                  inherit (config.programs.niri) package;
                  inherit (package.configuration.constructFiles.generatedConfig) outPath;
                in
                {
                  name = "niri-reload-config";
                  runtimeInputs = [
                    package
                    pkgs.procps
                  ];
                  text = ''
                    if pgrep -x "niri" > /dev/null; then
                      niri msg action load-config-file --path "${outPath}"
                    fi
                  '';
                }
              )
            );
          };
        };

        environment.shellAliases = {
          niri-log = ''journalctl --user -u niri --no-hostname -o cat | awk '{$1=""; print $0}' | sed 's/^ *//' | sed 's/\x1b[[0-9;]*m//g' '';
        };

      };
    };
}
