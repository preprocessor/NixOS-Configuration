{
  withSystem,
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.exo;
in
{
  config = {
    flake.nixosConfigurations =
      cfg.configurations
      |> lib.mapAttrs (
        hostname: hostConfig:
        withSystem hostConfig.system (
          {
            packages',
            inputs',
            self',
            ...
          }:
          inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit
                inputs
                self'
                inputs'
                packages'
                hostname
                ;
              inherit (hostConfig) hardware theme;
              inherit (inputs) birdee;
              constants = {
                username = hostConfig.user;
                stateVersion = hostConfig.stateVersion;
                homedir = "/home/${hostConfig.user}";
                cfgdir = "/home/${hostConfig.user}/Configuration/NixOS";
              };
            };
            modules = hostConfig.modules ++ [
              cfg.skeleton
              cfg.core
              cfg.hardware.${hostConfig.hardware}
              (cfg.host.${hostname} or { })
              hostConfig.extraConfig
              { networking.hostName = lib.mkDefault hostname; }
            ];
          }
        )
      );

    perSystem =
      { pkgs, ... }:
      {
        formatter = pkgs.nixfmt-rs;
      };
  };

  options.exo = {
    configurations = lib.mkOption {
      description = "NixOS Configuration";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { hostName, ... }:
          {
            options = {
              system = lib.mkOption {
                type = lib.types.str;
                default = "x86_64-linux";
                description = "The architecture of the system.";
              };

              stateVersion = lib.mkOption {
                type = lib.types.str;
                default = throw "Configuration failed: You must define a `stateVersion` for the host '${hostName}'.";
                description = "The primary user for this system.";
              };

              user = lib.mkOption {
                type = lib.types.str;
                default = throw "Configuration failed: You must define a `user` for the host '${hostName}'.";
                description = "The primary user for this system.";
              };

              hardware = lib.mkOption {
                type = lib.types.str;
                default = throw "Configuration failed: You must define a `hardware` profile for the host '${hostName}'.";
                description = "The hardware profile for this system.";
              };

              theme = lib.mkOption {
                type = lib.types.enum [
                  "light"
                  "dark"
                ];
                default = "dark";
                description = "The color theme for this system.";
              };

              modules = lib.mkOption {
                type = lib.types.listOf lib.types.deferredModule;
                default = [ ];
                description = "List of modules to include.";
              };

              extraConfig = lib.mkOption {
                type = lib.types.deferredModule;
                default = { };
                description = "configurations specific to this host.";
              };
            };
          }
        )
      );
    };
    mods = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
    };
    host = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
    };
    core = lib.mkOption {
      type = lib.types.deferredModule;
    };
    skeleton = lib.mkOption {
      type = lib.types.deferredModule;
    };
    hardware = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
    };
  };
}
