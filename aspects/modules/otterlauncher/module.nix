{ lib, ... }:
{
  envoy.otter-launcher.github = "kuokuo123/otter-launcher";

  perSystem =
    {
      pkgs,
      envoy,
      ...
    }:
    {
      packages.otter-launcher = pkgs.rustPlatform.buildRustPackage {
        inherit (envoy.otter-launcher) pname version src;
        cargoHash = "sha256-uDIUN2/EvMvEUWlIvgAOy9NLkpGI0CGs+QXnDiUtFxc=";
        patches = [
          (pkgs.writeText "selection.patch" # rust
            ''
              diff --git a/src/helper.rs b/src/helper.rs
              index 991b6bf..248f856 100644
              --- a/src/helper.rs
              +++ b/src/helper.rs
              @@ -463,6 +463,10 @@ impl Hinter for OtterHelper {
                           // make the number of filtered items globally accessible
                           FILTERED_HINT_COUNT.store(filtered_items.len(), Ordering::Relaxed);

              +            if !line.is_empty() && selection_index == 0 && !filtered_items.is_empty() {
              +                SELECTION_INDEX.store(1, Ordering::Relaxed);
              +            }
              +
                           // Check if there are enough filtered items after the skip
                           let agg_line = if hint_benchmark + suggestion_lines
                               > FILTERED_HINT_COUNT.load(Ordering::Relaxed)
              --
              2.53.0
            ''
          )
        ];
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
      birdee,
      config,
      self',
      pkgs,
      ...
    }:
    let
      cfg = config.wrappers.otter-launcher;
      toml = pkgs.formats.toml { };
    in
    {
      options.wrappers.otter-launcher = {
        enable = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into otter-launcher's toml config";
        };

        moreCfg = lib.mkOption {
          type = with lib.types; nullOr (either path lines);
          default = "";
          description = "Additional config lines.";
          example = lib.literalExpression "./config.toml";
        };

        package = lib.mkOption {
          default = birdee.lib.wrapPackage (
            { config, ... }:
            {
              inherit pkgs;
              package = self'.packages.otter-launcher;
              extraPackages = with pkgs; [
                pulsemixer
                fetchutils
                xrandr
                chafa
              ];
              flags = {
                "--config" = config.constructFiles.generatedConfig.path;
              };
              constructFiles.generatedConfig = {
                relPath = "config.toml";
                content = (cfg.settings |> toml.generate "config.toml" |> builtins.readFile) + cfg.moreCfg;
              };
            }
          );
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];
      };

      _file = ./module.nix;
    };
}
