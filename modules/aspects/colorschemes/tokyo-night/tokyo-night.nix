{
  w.tokyonight-night =
    { pkgs, lib, ... }:
    let
      inherit (pkgs) fetchFromGitHub;

      scheme =
        fetchFromGitHub {
          owner = "tinted-theming";
          repo = "schemes";
          rev = "3fa37f7b72d332b406fdc254008ed6d6b50efb4c";
          hash = "sha256-KIeHXjhlEh1wsyT6rITze7Hvc1L6fhgk30nPpcmrSrc=";
        }
        + "/base24/tokyo-night-dark.yaml";

      tokyonight =
        fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim";
          rev = "cdc07ac78467a233fd62c493de29a17e0cf2b2b6";
          hash = "sha256-a9iRWue7DB7s/wNdxqqB51Jya5P9X6sDftqhdmKggU0=";
        }
        + "/extras";

      tmTheme = tokyonight + "/sublime/tokyonight_night.tmTheme";

      tokyonight-yazi-theme =
        fetchFromGitHub {
          owner = "kalidyasin";
          repo = "yazi-flavors";
          rev = "70fe6b4a245a59b546166aae6c45ee2b471869c2";
          hash = "sha256-9I6NWIlNi4y0mNuqX8AbjfIK9vrC3+fzP0dJdh6QAic=";
        }
        + "/tokyonight-night.yazi";
      tokyonight-vesktop-theme = fetchFromGitHub {
        owner = "refact0r";
        repo = "system24";
        rev = "942c28771d1230567d65a5362814e0267317f455";
        hash = "sha256-2n4u+ibWDHRG84xo7u9posWX31JQ//80NZCZh5T/B9o=";
      };
    in
    {
      scheme = scheme; # Set base16 scheme
      stylix.base16Scheme = scheme; # Set stylix base16 scheme

      hj.xdg.config.files = {
        "ghostty/config".text = "theme = TokyoNight Night";
        "bat/themes/tokyonight.tmTheme".source = tmTheme;
        "bat/config".text = "--theme=tokyonight";
        "eza/theme.yml".source = tokyonight + "/eza/tokyonight_night.yml";
        "btop/themes/tokyonight_night.theme".source = tokyonight + "/btop/tokyonight_night.theme";
        "lazygit/config.yml".text = builtins.readFile "${tokyonight}/lazygit/tokyonight_night.yml";
        "vesktop/themes/tokyonight_system24.css".source =
          tokyonight-vesktop-theme + "/theme/flavors/system24-tokyo-night.theme.css";
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
