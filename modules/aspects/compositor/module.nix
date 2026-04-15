# Sources:
# https://github.com/iynaix/dotfiles/blob/7cfd3aec29feec3807206591260e594ad28094f9/modules/gui/niri/default.nix
# https://github.com/onelocked/NixOS/blob/master/modules/nixos/desktop/niri/niri.nix

{ inputs, ... }:
{
  flake-file.inputs = {
    niri.url = "github:niri-wm/niri";
    qml-niri.url = "github:imiric/qml-niri/main";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    system76-scheduler-niri.url = "github:Kirottu/system76-scheduler-niri";
  };

  flake.modules.nixos.desktop =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      niri = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;

      niri_wrapped = inputs.wrappers.wrappers.niri.wrap {
        inherit (config.custom.programs.niri) settings;
        inherit pkgs;
        v2-settings = false;
        package = lib.mkForce (
          niri.overrideAttrs (o: ({
            patches = [
              (pkgs.fetchpatch2 {
                name = "focus_ring_fade_animation_and_gradient_rotation.patch";
                url = "https://github.com/niri-wm/niri/pull/3577.patch";
                hash = "sha256-NQysXDDdH/Nru2imyBEHndy5UJmqtEsMIw7DmKCxy5U=";
              })
            ];

            doCheck = false; # faster builds
          }))
        );
      };
    in
    {
      programs.niri = {
        enable = true;
        useNautilus = false;
        package = niri_wrapped;
      };

      programs.uwsm = {
        enable = true;
        waylandCompositors = {
          niri = {
            prettyName = "niri";
            comment = "Niri compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/niri";
            # [NOTE] "/run/current-system/sw/bin/niri" is preferred to "lib.getExe pkgs.niri" avoid version mismatch
            extraArgs = [ "--session" ];
          };
        };
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

      environment.shellAliases = {
        niri-log = ''journalctl --user -u niri --no-hostname -o cat | awk '{$1=""; print $0}' | sed 's/^ *//' | sed 's/\x1b[[0-9;]*m//g' '';
      };

      hj.systemd.services.system76-scheduler-niri = {
        description = "Niri integration for system76-scheduler";
        after = [ "niri.service" ];
        wantedBy = [ "niri.service" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = lib.getExe (
            inputs.system76-scheduler-niri.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs {
              doCheck = false;
            }
          );
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      # restart niri with new settings on rebuild
      system.userActivationScripts = {
        niri-reload-config = {
          text = lib.getExe (
            pkgs.writeShellApplication {
              name = "niri-reload-config";
              runtimeInputs = [
                niri_wrapped
                pkgs.procps
              ];
              text = ''
                if pgrep -x "niri" > /dev/null; then
                  niri msg action load-config-file --path "${niri_wrapped.configuration.constructFiles.generatedConfig.outPath}"
                fi
              '';
            }
          );
        };
      };
    };

  flake.modules.nixos.default =
    { lib, pkgs, ... }:
    {
      options.custom = {
        programs.niri = {
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
    };
}
