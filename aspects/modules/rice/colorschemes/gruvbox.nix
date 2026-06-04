{
  envoy = {
    gruvbox-fish.github = "gruvbox-community/fish-gruvbox";
    gruvbox-lazygit.github = "im-AMS/gruvbox-material-lazygit";
    gruvbox.github = "gruvbox-community/gruvbox-contrib";
    eza-themes.github = "eza-community/eza-themes";
    gruvbox-discord.url = "https://raw.githubusercontent.com/round-panda/gruvbox-sharp/main/GruvboxSharp.theme.css";
  };

  w.gruvbox-dark-hard =
    {
      lib,
      envoy,
      pkgs,
      ...
    }:
    {
      scheme = {
        slug = "wysprtheme";
        scheme = "Wruvbox";
        author = "wyspr";

        base00 = "#282828"; # - Background
        base01 = "#3c3836"; # - Lighter background (terminal black)
        base02 = "#504945"; # - Selection background
        base03 = "#665c54"; # - Comments, invisibles
        base04 = "#928374"; # - Dark foreground
        base05 = "#ebdbb2"; # - Default foreground
        base06 = "#fbf1c7"; # - Light foreground
        base07 = "#f9f5d7"; # - Lightest foreground
        base08 = "#cc241d"; # red
        base09 = "#d65d0e"; # orange
        base0A = "#d79921"; # yellow
        base0B = "#98971a"; # green
        base0C = "#689d6a"; # cyan
        base0D = "#458588"; # blue
        base0E = "#b16286"; # magenta
        base0F = "#9d0006"; # brown
        base10 = "#2a2520"; # - Darker background
        base11 = "#1d1d1d"; # - Darkest background
        base12 = "#fb4934"; # bright-red
        base13 = "#fabd2f"; # bright-yellow
        base14 = "#b8bb26"; # bright-green
        base15 = "#8ec07c"; # bright-cyan
        base16 = "#83a598"; # bright-blue
        base17 = "#d3869b"; # bright-magenta
      };

      wrappers.kitty.settings.theme = builtins.readFile (
        envoy.gruvbox.src + "/kitty/gruvbox-dark-hard.conf"
      );

      # programs.bash.interactiveShellInit = lib.mkAfter "source ${envoy.gruvbox.src + "/shell/colors.sh"}";
      #
      # programs.fish.shellInit = ''
      #   source ${envoy.gruvbox-fish.src}/functions/theme_gruvbox.fish
      #   theme_gruvbox dark hard
      # '';

      hj.xdg.config.files = {
        "bat/config".text = "--theme=gruvbox-dark";
        "eza/theme.yml".source = envoy.eza-themes.src + "/themes/gruvbox-dark.yml";
        "lazygit/config.yml".text =
          builtins.readFile "${envoy.gruvbox-lazygit.src}/themes/dark_hard_original.yml";
      };

      # [TODO] make this better
      hj.xdg.config.files."vesktop/themes/gruvbox-dark-hard.css".source = envoy.gruvbox-discord.src;
      custom.programs.vesktop.vencord.settings.enabledThemes = [ "gruvbox-dark-hard.css" ];

      custom.gtk = {
        enable = true;

        theme = {
          name = "Gruvbox-Yellow-Dark";
          package = pkgs.gruvbox-gtk-theme.override {
            colorVariants = [ "dark" ];
            # sizeVariants = [ "compact" ];
            themeVariants = [ "yellow" ];
          };
        };

        icons = {
          name = "Tela-orange-dark";
          package = pkgs.tela-icon-theme;
        };
      };

      _file = "gruvbox.nix";
    };
}
