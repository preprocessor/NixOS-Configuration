{
  envoy = {
    colorscheme.github = "tinted-theming/schemes";
    tokyonight.github = "folke/tokyonight.nvim";
    tokyonight-yazi-theme.github = "kalidyasin/yazi-flavors";
    tokyonight-vesktop-theme.github = "ForRealy/Tokyo-Night-fixed";
  };

  w.tokyonight-night =
    {
      envoy,
      config,
      pkgs,
      lib,
      ...
    }:
    let
      colorscheme = envoy.colorscheme.src + "/base24/tokyo-night-dark.yaml";

      tokyonight = envoy.tokyonight.src + "/extras";

      tmTheme = tokyonight + "/sublime/tokyonight_night.tmTheme";

      tokyonight-yazi-theme = envoy.tokyonight-yazi-theme.src + "/tokyonight-night.yazi";

      tokyonight-vesktop-theme = envoy.tokyonight-vesktop-theme.src;
    in
    {
      scheme = colorscheme; # Set base16 scheme

      hj.xdg.config.files = {
        "ghostty/config".text = "theme = TokyoNight Night";
        "bat/themes/tokyonight.tmTheme".source = tmTheme;
        "bat/config".text = "--theme=tokyonight";
        "eza/theme.yml".source = tokyonight + "/eza/tokyonight_night.yml";
        "btop/themes/tokyonight_night.theme".source = tokyonight + "/btop/tokyonight_night.theme";
        "lazygit/config.yml".text = builtins.readFile "${tokyonight}/lazygit/tokyonight_night.yml";
      };

      programs.fish.interactiveShellInit = builtins.readFile (tokyonight + "/fish/tokyonight_night.fish");

      custom.programs.yazi = {
        flavors.tokyonight = tokyonight-yazi-theme;

        theme.flavor = {
          dark = "tokyonight";
          light = "tokyonight";
        };
      };

      custom.programs.fuzzel.moreCfg = builtins.readFile "${tokyonight}/fuzzel/tokyonight_night.ini";

      hj.xdg.config.files."vesktop/themes/tokyonight.css".source =
        tokyonight-vesktop-theme + "/themes/tokyo-night.theme.css";
      custom.programs.vesktop.vencord.settings.enabledThemes = [ "tokyonight.css" ];

      custom.programs.kitty.settings.theme =
        builtins.readFile "${tokyonight}/kitty/tokyonight_night.conf";
    };
}

# system: "base24"
# name: "Tokyo Night Dark"
# author: "Michaël Ball, based on Tokyo Night by enkia (https://github.com/enkia/tokyo-night-vscode-theme)"
# variant: "dark"
# palette:
#   base00: "#1a1b26" # Background
#   base01: "#16161e" # Lighter background (terminal black)
#   base02: "#2f3549" # Selection background
#   base03: "#444b6a" # Comments, invisibles
#   base04: "#787c99" # Dark foreground
#   base05: "#a9b1d6" # Default foreground
#   base06: "#cbccd1" # Light foreground
#   base07: "#d5d6db" # Lightest foreground
#   base08: "#c0caf5" # Variables, XML tags
#   base09: "#a9b1d6" # Integers, booleans
#   base0A: "#0db9d7" # Classes, search text bg
#   base0B: "#9ece6a" # Strings
#   base0C: "#b4f9f8" # Regex, escape chars
#   base0D: "#2ac3de" # Functions, methods
#   base0E: "#bb9af7" # Keywords, storage
#   base0F: "#f7768e" # Deprecated, special
#   base10: "#16161e" # Darker background
#   base11: "#0f0f14" # Darkest background
#   base12: "#ff7a93" # Bright red
#   base13: "#ff9e64" # Bright orange
#   base14: "#73daca" # Bright green/teal
#   base15: "#7dcfff" # Bright cyan
#   base16: "#89ddff" # Bright blue
#   base17: "#bb9af7" # Bright magenta
#
# mnemonic = {
#   red = base08;
#   orange = base09;
#   yellow = base0A;
#   green = base0B;
#   cyan = base0C;
#   blue = base0D;
#   magenta = base0E;
#   brown = base0F;
#   bright-red = base12 or base08;
#   bright-yellow = base13 or base0A;
#   bright-green = base14 or base0B;
#   bright-cyan = base15 or base0C;
#   bright-blue = base16 or base0D;
#   bright-magenta = base17 or base0E;
# };
