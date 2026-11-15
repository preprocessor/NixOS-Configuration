{
  lib,
  config,
  mkScheme,
  mkSystem,
  ...
}:
let
  cfg = config.modules;
in
{
  config = {
    flake.nixosConfigurations =
      cfg.configurations
      |> lib.mapAttrs (
        name: hostConfig:
        mkSystem name {
          inherit (hostConfig) system;

          modules = hostConfig.modules ++ [
            cfg.core
            (cfg.hardware.${hostConfig.hardware}
              or (throw "Configuration failed: unknown hardware profile '${hostConfig.hardware}' for host '${name}'. Available profiles: ${lib.concatStringsSep ", " (lib.attrNames cfg.hardware)}")
            )
            (cfg.host.${name} or { })
            hostConfig.extraConfig
          ];

          extraSpecialArgs = {
            hostname = name;
            inherit (hostConfig) hardware;
            scheme = mkScheme config.schemes.${hostConfig.scheme};
            constants = {
              username = hostConfig.user;
              stateVersion = hostConfig.stateVersion;
              homedir = "/home/${hostConfig.user}";
              cfgdir = "/home/${hostConfig.user}/Configuration/NixOS";
            };
          };
        }
      );

    systems = lib.mkDefault (
      let
        hostSystems =
          cfg.configurations
          |> lib.attrValues
          |> map (host: host.system)
          |> lib.unique;
      in
      if hostSystems == [ ] then [ "x86_64-linux" ] else hostSystems
    );
  };

  options.modules = {
    configurations = lib.mkOption {
      description = "NixOS Configuration";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              system = lib.mkOption {
                type = lib.types.str;
                default = "x86_64-linux";
                description = "The architecture of the system.";
              };

              stateVersion = lib.mkOption {
                type = lib.types.str;
                default = throw "Configuration failed: You must define a `stateVersion` for the host '${name}'.";
                description = "The NixOS state version for this system.";
              };

              user = lib.mkOption {
                type = lib.types.str;
                default = throw "Configuration failed: You must define a `user` for the host '${name}'.";
                description = "The primary user for this system.";
              };

              hardware = lib.mkOption {
                type = lib.types.str;
                default = throw "Configuration failed: You must define a `hardware` profile for the host '${name}'.";
                description = "The hardware profile for this system.";
              };

              scheme = lib.mkOption {
                type = lib.types.enum (lib.attrNames config.schemes);
                description = "The colorscheme for this system.";
              };

              modules = lib.mkOption {
                type = lib.types.listOf lib.types.deferredModule;
                default = [ ];
                description = "List of modules to include.";
              };

              extraConfig = lib.mkOption {
                type = lib.types.deferredModule;
                default = { };
                description = "Configurations specific to this host.";
              };
            };
          }
        )
      );
    };
    features = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
    };
    host = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
    };
    core = lib.mkOption {
      type = lib.types.deferredModule;
      default = { };
    };
    hardware = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = { };
    };
  };
}
