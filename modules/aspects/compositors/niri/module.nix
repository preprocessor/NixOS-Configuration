{ inputs, self, ... }:
{
  flake-file.inputs = {
    niri.url = "github:niri-wm/niri/wip/branch";
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
      inherit (config.custom.programs.niri) settings;

      source = lib.getExe config.programs.niri.package;
      niri_wrapped =

        (inputs.wrappers.wrappers.niri.wrap {
          inherit pkgs settings;
          v2-settings = false;
          package = (
            pkgs.niri.overrideAttrs (
              o:
              (
                source
                // {
                  inherit (o) version; # needed for annoying version check

                  postPatch = ''
                    patchShebangs resources/niri-session
                    substituteInPlace resources/niri.service \
                      --replace-fail 'ExecStart=niri' "ExecStart=$out/bin/niri"
                  '';

                  # creating an overlay for buildRustPackage overlay (NOTE: this is an IFD)
                  # https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
                  cargoDeps = pkgs.rustPlatform.importCargoLock {
                    lockFile = "${source.src}/Cargo.lock";
                    allowBuiltinFetchGit = true;
                  };

                  patches = (o.patches or [ ]) ++ [
                    # unmerged PR to fix this
                    # https://github.com/YaLTeR/niri/pull/3004
                    ./transparent-fullscreen.patch
                  ];

                  doCheck = false; # faster builds
                }
              )
            )
          );
        }).wrapper;

      niri_overlay = final: prev: {
        niri = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
    in
    {
      nixpkgs.overlays = [ niri_overlay ];

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
            binPath = "${lib.getExe config.programs.niri.package}"; # NOTE: /run/current-system/sw/bin/niri is more preferred to avoid version mismatch
            extraArgs = [ "--session" ];
          };
        };
      };
      services = {
        displayManager.enable = lib.mkForce false;
        greetd = {
          enable = true;
          useTextGreeter = true;
          settings = {
            default_session = {
              command = "${lib.getExe pkgs.tuigreet} --cmd ${lib.getExe config.programs.uwsm.package} start niri-uwsm.desktop";
              user = self.const.username;
            };
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
              freeformType = (pkgs.formats.json { }).type;
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
