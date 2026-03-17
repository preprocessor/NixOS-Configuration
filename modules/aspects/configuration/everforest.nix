{
  flake.modules.nixos.ramiel =
    { pkgs, ... }:
    let
      scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    in
    {
      scheme = scheme; # Set base16 scheme
      stylix.base16Scheme = scheme; # Set stylix base16 scheme
    };

  flake.modules.homeManager.ramiel =
    { lib, pkgs, ... }:
    {
      gtk = {
        theme = lib.mkDefault {
          name = "Everforest-Dark-Medium";
          package = pkgs.everforest-gtk-theme;
        };
        iconTheme = lib.mkDefault {
          name = "Everforest-Dark";
          package = pkgs.everforest-gtk-theme;
        };
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      };
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
