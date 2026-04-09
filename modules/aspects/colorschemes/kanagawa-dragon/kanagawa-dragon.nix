{ inputs, ... }:
{
  flake-file.inputs = {
    colorschemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    kanagawa-tmtheme = {
      url = "github:obergodmar/kanagawa-tmTheme";
      flake = false;
    };

    kanagawa-yazi-theme = {
      url = "github:marcosvnmelo/kanagawa-dragon.yazi";
      flake = false;
    };
  };

  flake.modules.nixos.kanagawa-dragon =
    { pkgs, ... }:
    let
      scheme = inputs.colorschemes + "/base24/kanagawa-dragon.yaml";
    in
    {
      scheme = scheme; # Set base16 scheme
      stylix.base16Scheme = scheme; # Set stylix base16 scheme
    };

  flake.modules.homeManager.kanagawa-dragon =
    { lib, pkgs, ... }:
    {
      programs.bat.config.theme = "kanagawa-dragon";
      xdg.configFile."bat/themes/kanagawa-dragon.tmTheme".source =
        inputs.kanagawa-tmtheme + "/Kanagawa Dragon.tmTheme";

      programs.delta.options.include.path = inputs.kanagawa-tmtheme + "/Kanagawa Dragon.tmTheme";

      programs.yazi = {
        flavors.kanagawa-dragon = inputs.kanagawa-yazi-theme;

        theme.flavor = {
          dark = "kanagawa-dragon";
          light = "kanagawa-dragon";
          use = "kanagawa-dragon";
        };
      };

      gtk = {
        theme = lib.mkDefault {
          name = "Kanagawa-Dragon-BL-LB";
          package = pkgs.kanagawa-gtk-theme;
        };
        iconTheme = lib.mkDefault {
          name = "Kanagawa";
          package = pkgs.kanagawa-icon-theme;
        };
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      };

      stylix.targets = {
        vesktop.enable = true;
      };

      programs.ghostty.settings.theme = "Kanagawa Dragon";
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
