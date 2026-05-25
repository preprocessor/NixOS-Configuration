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
      cfg = config.wrappers.fsel;
    in
    {
      options.wrappers.niri = {
        enable = lib.mkEnableOption { };
        withUWSM = lib.mkEnableOption { };
        withTermFileChooser = lib.mkEnableOption { };
        withHotReload = lib.mkEnableOption { };

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

      config = lib.mkIf cfg.enable {

        hj.packages = [ cfg.package ];
        services.graphical-desktop.enable = true;
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
            extraPortals = [
              pkgs.xdg-desktop-portal-gnome
            ]
            ++ lib.optional (!cfg.withTermFileChooser) pkgs.xdg-desktop-portal-gtk;
          };
        };

        environment.shellAliases = {
          niri-log = ''journalctl --user -u niri --no-hostname -o cat | awk '{$1=""; print $0}' | sed 's/^ *//' | sed 's/\x1b[[0-9;]*m//g' '';
        };

        programs.uwsm.waylandCompositors = lib.mkIf cfg.withUWSM {
          niri = {
            prettyName = "niri";
            comment = "Niri compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/niri";
            # [NOTE] "/run/current-system/sw/bin/niri" is preferred to "lib.getExe pkgs.niri" avoid version mismatch
            extraArgs = [ "--session" ];
          };
        };

        programs.bash.interactiveShellInit = lib.mkIf cfg.withUWSM (
          lib.mkOrder 0 /* bash */ ''
            # Auto start wayland session on tty1
            if [[ $(tty) == '/dev/tty1' ]]; then
              exec uwsm start niri-uwsm.desktop
            fi
          ''
        );

        custom.xdg.desktopEntries = lib.mkIf cfg.withUWSM {
          "uuctl".noDisplay = true;
        };

        # restart niri with new settings on rebuild
        system.userActivationScripts = lib.mkIf cfg.withHotReload {
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
      };
    };
}
