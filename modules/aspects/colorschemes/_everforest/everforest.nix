{ inputs, ... }:
{

  w.everforest =
    { pkgs, ... }:
    let
      scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";

      yazi-theme-everforest = pkgs.fetchFromGitHub {
        owner = "Chromium-3-Oxide";
        repo = "everforest-medium.yazi";
        rev = "a074b041871b43d1248a76f0a54465c5dd1034a7";
        hash = "sha256-tNULJOsOiVRcCtr/mXRnQY4gsbjZbgxcjN4vVCtbl2I=";
      };

      everforest-theme-collection = pkgs.fetchFromGitHub {
        owner = "neuromaancer";
        repo = "everforest_collection";
        rev = "ec3936e65699f38f8a9b1468d6ac20a25423d5af";
        hash = "sha256-HQQzmSYcQY4jYyk7zyxdOSJylqJl4aBobT37pST6AXE=";
      };
    in
    {
      scheme = scheme; # Set base16 scheme
      stylix.base16Scheme = scheme; # Set stylix base16 scheme
    };

  flake.modules.homeManager.everforest =
    { lib, pkgs, ... }:
    {
      programs.bat.config.theme = "everforest";
      xdg.configFile."bat/themes/everforest.tmTheme".source = ./everforest2.tmTheme;
      # xdg.configFile."bat/themes/everforest.tmTheme".source =
      #   "${inputs.everforest-theme-collection}/bat/everforest-soft.tmTheme";

      programs.yazi = {
        flavors.everforest-medium = inputs.yazi-theme-everforest;

        theme.flavor = {
          dark = "everforest-medium";
          light = "everforest-medium";
          use = "everforest-medium";
        };
      };

      gtk = {
        theme = lib.mkDefault {
          name = "Everforest-Dark-Medium";
          package = pkgs.everforest-gtk-theme;
        };
        iconTheme = lib.mkDefault {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      };

      programs.vesktop.vencord.settings.themeLinks = [
        "https://raw.githubusercontent.com/F0XX00/midnight-everforest-discord/501e9fef6e208cffc4ea68f0c292976d28230fed/midnight-everforest.theme.css"
      ];

      programs.ghostty.settings.theme = "Everforest Dark Hard";

    };
}

# base00: "#272e33" bg0,
# base01: "#2e383c" bg1,
# base02: "#414b50" bg3,
# base03: "#859289" grey1,
# base04: "#9da9a0" grey2,
# base05: "#d3c6aa" fg,
# base06: "#edeada" bg3,
# base07: "#fffbef" bg0,
# base08: "#e67e80" red,
# base09: "#e69875" orange,
# base0A: "#dbbc7f" yellow,
# base0B: "#a7c080" green,
# base0C: "#83c092" aqua,
# base0D: "#7fbbb3" blue,
# base0E: "#d699b6" purpl,
# base0F: "#9da9a0" grey2,
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
