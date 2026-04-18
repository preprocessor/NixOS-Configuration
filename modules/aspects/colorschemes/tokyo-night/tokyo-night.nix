{ inputs, ... }:
{
  flake-file.inputs = {
    colorschemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    tokyonight-theme = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    tokyonight-yazi-theme = {
      url = "github:kalidyasin/yazi-flavors";
      flake = false;
    };
  };

  flake.modules.nixos.tokyonight-night =
    { pkgs, ... }:
    let
      scheme = inputs.colorschemes + "/base24/tokyo-night-dark.yaml";
      tmTheme = inputs.tokyonight-theme + "/extras/sublime/tokyonight_night.tmTheme";
      tnExtras = inputs.tokyonight-theme + "/extras";
    in
    {
      scheme = scheme; # Set base16 scheme
      stylix.base16Scheme = scheme; # Set stylix base16 scheme

      hj.xdg.config.files."ghostty/config".text = "theme = TokyoNight Night";

      hj.xdg.config.files."bat/themes/tokyonight.tmTheme".source = tmTheme;
      hj.xdg.config.files."bat/config".text = "--theme=tokyonight";

      hj.xdg.config.files."eza/theme.yml".source = tnExtras + "/eza/tokyonight_night.yml";

      programs.fish.interactiveShellInit = builtins.readFile "${tnExtras}/fish/tokyonight_night.fish";

      hj.xdg.config.files."lazygit/config.yml".text =
        builtins.readFile "${tnExtras}/lazygit/tokyonight_night.yml";

      hj.xdg.config.files."btop/themes/tokyonight_night.theme".source =
        tnExtras + "/btop/tokyonight_night.theme";

      # hj.xdg.config.files."yazi/flavors/tokyonight.yazi/".source =
      #   inputs.tokyonight-yazi-theme + "/tokyonight-night.yazi";

      custom.programs.yazi.settings = {
        flavors = {
          tokyonight = inputs.tokyonight-yazi-theme + "/tokyonight-night.yazi";
        };

        theme.flavor = {
          dark = "tokyonight";
          light = "tokyonight";
        };
      };
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
