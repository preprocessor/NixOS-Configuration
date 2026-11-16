{
  modules.core = {
    my.starship = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        add_newline = false;

        right_format = "$nix_shell";

        nix_shell.format = "[ nix-shell](cyan)";

        git_status.format = "[($all_status$ahead_behind)](fg:blue bold)";

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
          home_symbol = "󰜥";
        };

        directory.substitutions = {
          "NixOS" = " ";
        };

        git_branch = {
          symbol = "";
          format = "[ $symbol $branch](fg:blue bold)";
        };
      };
    };
  };

  modules.host.ramiel = {
    my.starship.settings.format = "$directory$git_branch$character";
  };

  modules.host.xyz = {
    my.starship.settings.format = "$hostname$directory$git_branch";
  };
}
