{
  flake.modules.homeManager.default = {
    programs.starship = {
      enable = true;
      enableInteractive = false;
      enableFishIntegration = true;
      enableBashIntegration = true;

      enableTransience = true;

      settings = {
        add_newline = false;

        right_format = "$nix_shell";

        format = "[](fg:blue)$directory[](fg:blue)$git_branch$character";

        nix_shell = {
          format = "[ nix-shell](cyan)";
        };

        character = {
          success_symbol = " [](green) ";
          error_symbol = " [](red) ";
          vimcmd_symbol = " [󰏤](blue) ";
          vimcmd_visual_symbol = " [󰈈](blue) ";
        };

        directory = {
          style = "fg:#272E33 bg:blue bold";
          format = "[$path]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
          home_symbol = "🐸";
        };

        # directory.substitutions = {
        #   ".config" = "⚙︎ ";
        #   "nvim" = "  ";
        # };

        git_branch = {
          symbol = "";
          format = " [ $symbol $branch ](fg:blue bold)";
        };

        git_status = {
          format = "[($all_status$ahead_behind )](fg:blue bold)";
        };
      };
    };

  };
}
