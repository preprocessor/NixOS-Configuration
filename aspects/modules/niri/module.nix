# Sources:
# https://github.com/iynaix/dotfiles/blob/7cfd3aec29feec3807206591260e594ad28094f9/modules/gui/niri/default.nix
# https://github.com/onelocked/NixOS/blob/master/modules/nixos/desktop/niri/niri.nix
{
  ff.niri = {
    url = "github:niri-wm/niri";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  perSystem =
    { pkgs, inputs', ... }:
    {
      packages.niri = inputs'.niri.packages.niri.overrideAttrs (o: {
        patches = [
          # (pkgs.fetchpatch2 {
          #   name = "feat-layer-animations";
          #   url = "https://github.com/niri-wm/niri/pull/3481.patch";
          #   hash = "sha256-O3TNnppkT4ZsXkXHSzRzWj6k4nzLomjxNIz07GTnTOg=";
          # })
          ./patches/feat-add-focus-ring-fade-animation-and-gradient-rotation.patch # https://github.com/niri-wm/niri/pull/3577.patch
          ./patches/transparent-fullscreen.patch
        ];

        doCheck = false; # faster builds
      });

      _file = ./module.nix;
    };

  w.default =
    {
      lib,
      pkgs,
      self',
      config,
      birdee,
      ...
    }:
    let
      cfg = config.wrappers.niri;
    in
    {
      options.wrappers.niri = {
        enable = lib.mkEnableOption { };
        withUWSM = lib.mkEnableOption { };
        withTermFileChooser = lib.mkEnableOption { };
        withHotReload = lib.mkEnableOption { };
        withAutostart = lib.mkEnableOption { };

        package = lib.mkOption {
          default = birdee.wrappers.niri.wrap {
            inherit (cfg) settings;
            inherit pkgs;
            v2-settings = false;
            disableConfigHotReload = true;
            package = lib.mkForce self'.packages.niri;
          };
        };

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

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            hj.packages = [ cfg.package ];
            xdg.portal = {
              configPackages = [ cfg.package ];
              config = {
                niri = {
                  default = lib.mkForce [ "gnome" ];
                  "org.freedesktop.impl.portal.FileChooser" = lib.mkForce (
                    if cfg.withTermFileChooser then [ "termfilechooser" ] else [ "gtk" ]
                  );
                  "org.freedesktop.impl.portal.Secret" = lib.mkForce [ "gnome-keyring" ];
                  "org.freedesktop.impl.portal.Chooser" = lib.mkForce [ "none" ];
                };
              };
              extraPortals = [
                pkgs.xdg-desktop-portal-gnome
              ]
              ++ lib.optional (!cfg.withTermFileChooser) pkgs.xdg-desktop-portal-gtk;
            };
            services.graphical-desktop.enable = true;
            services.speechd.enable = lib.mkForce false;
          }

          (lib.mkIf cfg.withAutostart {
            programs.bash.interactiveShellInit =
              let
                session =
                  if cfg.withUWSM then # bash
                    "exec uwsm start niri-uwsm.desktop"
                  else
                    lib.getExe' cfg.package "niri-session";
              in

              lib.mkOrder 0 /* bash */ ''
                # Auto start wayland session on tty1
                if [[ $(tty) == '/dev/tty1' ]]; then
                  ${session}
                fi
              '';
          })

          (lib.mkIf cfg.withHotReload {
            system.userActivationScripts = {
              niri-reload-config = {
                text = lib.getExe (
                  pkgs.writeShellApplication (
                    let
                      inherit (cfg) package;
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
          })

          (lib.mkIf cfg.withUWSM {
            custom.xdg.desktopEntries."uuctl".noDisplay = true;
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
          })

          (lib.mkIf (!cfg.withUWSM) {
            services.displayManager.sessionPackages = [ cfg.package ];
          })

          # (lib.mkIf (config.forte.startup != [ ]) {
          #   forte.niri.settings = lib.mkMerge (
          #     config.forte.startup
          #     |> lib.filter (startup: startup.enable)
          #     |> map (startup: {
          #       spawn-at-startup = [ startup.spawn ];
          #       window-rules = lib.optional (startup.app-id != null) (
          #         {
          #           matches = [ { inherit (startup) app-id; } ];
          #         }
          #         // (lib.optionalAttrs (startup.workspace != null) {
          #           open-on-workspace = toString startup.workspace;
          #         })
          #         // startup.niriArgs
          #       );
          #     })
          #   );
          # })
        ]
      );

      _file = ./module.nix;
    };
}
