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
    let
      kitty = envoy.gruvbox.src + "/kitty/gruvbox-dark-hard.conf";
      bash = envoy.gruvbox.src + "/shell/colors.sh";
    in
    {
      hj.packages = with pkgs; [ gruvbox-dark-gtk ];
      scheme = envoy.schemes.src + "/base24/gruvbox-dark.yaml";

      wrappers.kitty.settings.theme = builtins.readFile kitty;

      programs.bash.interactiveShellInit = lib.mkAfter "source ${bash}";

      programs.fish.shellInit = ''
        source ${envoy.gruvbox-fish.src}/functions/theme_gruvbox.fish
        theme_gruvbox dark hard
      '';

      hj.xdg.config.files = {
        "bat/config".text = "--theme=gruvbox-dark";
        "eza/theme.yml".source = envoy.eza-themes.src + "/themes/gruvbox-dark.yml";
        "lazygit/config.yml".text =
          builtins.readFile "${envoy.gruvbox-lazygit.src}/themes/dark_hard_original.yml";
      };

      hj.xdg.config.files."vesktop/themes/gruvbox-dark-hard.css".source = envoy.gruvbox-discord.src;
      custom.programs.vesktop.vencord.settings.enabledThemes = [ "gruvbox-dark-hard.css" ];

      custom.gtk = {
        enable = true;

        theme = {
          name = "Gruvbox-Dark";
          package = pkgs.gruvbox-gtk-theme.override {
            colorVariants = [ "dark" ];
            # sizeVariants = [ "compact" ];
            themeVariants = [ "all" ];
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
