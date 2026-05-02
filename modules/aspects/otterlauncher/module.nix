{
  envoy.otter-launcher.github = "kuokuo123/otter-launcher";

  perSystem =
    {
      pkgs,
      lib,
      envoy,
      ...
    }:
    {
      packages.otter-launcher = pkgs.rustPlatform.buildRustPackage {
        inherit (envoy.otter-launcher) pname version src;
        cargoHash = "sha256-AlzCrK6DivOfCMGXQsiMJ+7Ahtd/9qoJ0MKZrez6xyM=";
        meta = {
          description = "A hackable cli/tui launcher built for keyboard-centric wm users, featuring vi & emacs keybinds, ansi decoration, etc";
          homepage = "https://github.com/kuokuo123/otter-launcher";
          license = lib.licenses.gpl3Only;
          mainProgram = "otter-launcher";
        };
      };
    };

  w.default =
    {
      self',
      wrappers,
      pkgs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.custom.programs.otter-launcher;
      toml = pkgs.formats.toml { };
    in
    {
      options.custom.programs.otter-launcher = {
        enable = lib.mkEnableOption { };
        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into otter-launcher's toml config";
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [
          (wrappers.lib.wrapPackage (
            { config, ... }:
            {
              inherit pkgs;
              package = self'.packages.otter-launcher;
              extraPackages = with pkgs; [
                chafa
                pulsemixer
              ];
              flags."--config" = config.constructFiles.otter-config.path;
              constructFiles.otter-config = {
                relPath = "config.toml";
                content = cfg.settings |> toml.generate "config.toml" |> builtins.readFile;
              };
            }
          ))
        ];
      };
    };
}
