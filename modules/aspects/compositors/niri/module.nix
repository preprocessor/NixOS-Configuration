{ inputs, ... }:
{
  flake-file.inputs = {
    niri.url = "github:niri-wm/niri";
    qml-niri.url = "github:imiric/qml-niri/main";
    wrappers.url = "github:Lassulus/wrappers";
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

      niri_wrapped = (inputs.wrappers.wrapperModules.niri.apply { inherit pkgs settings; }).wrapper;

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

      systemd.user.services.system76-scheduler-niri = {
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
    };

  flake.modules.nixos.default =
    { lib, pkgs, ... }:
    {
      options.custom = {
        programs.niri = {
          settings = lib.mkOption {
            type = lib.types.submodule {
              freeformType = (pkgs.formats.json { }).type;
              # strings don't merge by default
              options.extraConfig = lib.mkOption {
                type = lib.types.lines;
                default = "";
                description = "Additional configuration lines.";
              };
            };
            description = "Niri settings, see https://github.com/Lassulus/wrappers/blob/main/modules/niri/module.nix for available options";
          };
        };
      };
    };
}
