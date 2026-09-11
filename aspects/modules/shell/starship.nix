{
  exo.skeleton =
    {
      wrapPackage,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.starship;
      toml = pkgs.formats.toml { };
    in
    {
      options.my.starship = {
        enable = lib.mkEnableOption { };

        enableFishIntegration = lib.mkEnableOption { };

        settings = lib.mkOption {
          inherit (toml) type;
          default = { };
          description = "Options to go into starship's toml config";
        };

        package = lib.mkOption {
          default = wrapPackage (
            { files, wlib, ... }:
            {
              package = pkgs.starship;
              env.STARSHIP_CONFIG = files.config;
              files.config = {
                relPath = "config/starship.toml";
                file = wlib.toml "starship.toml" cfg.settings;
              };
            }
          );
        };
      };

      config = lib.mkIf (cfg.enable) {
        hj.packages = [ cfg.package ];

        programs.fish.interactiveShellInit = lib.mkIf (cfg.enableFishIntegration) ''
          if test "$TERM" != "dumb"
            ${lib.getExe cfg.package} init fish | source
            enable_transience
          end
        '';
      };
    };

  exo.core =
    { config, ... }:
    let
      theme = config.theme.variant;
    in
    {
      my.starship = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          add_newline = false;

          right_format = "$nix_shell";

          format = "$directory$git_branch$character";

          nix_shell = {
            format = "[ nix-shell](cyan)";
          };

          character = {
            success_symbol = " [](bright-green) ";
            error_symbol = " [](bright-red) ";
            vimcmd_symbol = " [󰏤](bright-blue) ";
            vimcmd_visual_symbol = " [󰈈](bright-yellow) ";
          };

          directory = {
            style = "bold";
            format = "[$path]($style)";
            truncation_length = 3;
            truncation_symbol = "…/";
            home_symbol = if (theme == "dark ") then "🐸" else "󰜥";
          };

          directory.substitutions = {
            "NixOS" = " ";
          };

          git_branch = {
            symbol = "";
            format = "[ $symbol $branch](fg:blue bold)";
          };

          git_status = {
            format = "[($all_status$ahead_behind)](fg:blue bold)";
          };
        };
      };
    };
}
