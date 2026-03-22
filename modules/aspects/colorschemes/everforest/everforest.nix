{ inputs, ... }:
{
  flake-file.inputs.yazi-theme-everforest = {
    url = "github:Chromium-3-Oxide/everforest-medium.yazi";
    flake = false;
  };

  flake.modules.nixos.everforest =
    { pkgs, ... }:
    let
      scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    in
    {
      scheme = scheme; # Set base16 scheme
      stylix.base16Scheme = scheme; # Set stylix base16 scheme
    };

  flake.modules.homeManager.everforest =
    { lib, pkgs, ... }:
    {
      xdg.configFile."bat/themes/everforest.tmTheme".text = lib.readFile ./everforest.tmTheme;
      programs.bat.config.theme = "everforest";

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

      programs.zellij.settings.theme = "everforest-dark";
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
