{
  w.default =
    {
      config,
      pkgs,
      lib,
      wrappers,
      ...
    }:
    let
      toml = pkgs.formats.toml { };
      starshipWrapped = wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.starship;
        env.STARSHIP_CONFIG = toml.generate "starship.toml" {
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
            home_symbol = "🐸";
          };

          # directory.substitutions = {
          #   ".config" = "⚙︎ ";
          #   "nvim" = "  ";
          # };

          git_branch = {
            symbol = "";
            format = "[ $symbol $branch](fg:blue bold)";
          };

          git_status = {
            format = "[($all_status$ahead_behind)](fg:blue bold)";
          };
        };
      };
    in
    {
      hj.packages = [ starshipWrapped ];

      programs.fish.interactiveShellInit = ''
        if test "$TERM" != "dumb"
          ${lib.getExe starshipWrapped} init fish | source
          enable_transience
        end
      '';
    };
}
