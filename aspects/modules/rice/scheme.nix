{
  exo.core = {
    theme = {
      variant = "light";
      dark = {
        slug = "wyspr-evangelion";
        scheme = "MAGI";
        author = "wyspr";

        base00 = "#111111"; # Default background
        base01 = "#484848"; # Lighter bg / status bars
        base02 = "#9B9B9B"; # Selection background
        base03 = "#B0B0B0"; # Comments, invisibles
        base04 = "#C4C4C8"; # Dark bg highlight (tab_bar_background)
        base05 = "#EC7420"; # Default foreground
        base06 = "#EE8236"; # Light foreground
        base07 = "#F08E4A"; # Lightest foreground
        base08 = "#b8201a"; # Red — variables, errors
        base09 = "#E8E8E8"; # Orange — integers, booleans
        base0A = "#c28a1e"; # Yellow — classes
        base0B = "#898817"; # Green — strings
        base0C = "#5e8d5f"; # Cyan — escape chars, regex
        base0D = "#3e787a"; # Blue — functions
        base0E = "#9f5879"; # Magenta — keywords
        base0F = "#F3505D"; # Brown — deprecated
        base10 = "#0A0A0A"; # Darker background (base00 stepped down)
        base11 = "#000000"; # Darkest background (stepped further)
        base12 = "#fb5b48"; # Bright red
        base13 = "#fbc444"; # Bright yellow (bell_border / mark2)
        base14 = "#bfc23c"; # Bright green
        base15 = "#8faea2"; # Bright blue
        base16 = "#d792a5"; # Bright magenta
        base17 = "#99c689"; # Bright cyan
      };

      light = {
        slug = "wyspr-jojo";
        scheme = "BIZZARE";
        author = "wyspr";

        base00 = "#101010"; # Default background
        base01 = "#3A3A3A"; # Lighter bg / status bars
        base02 = "#AAAAAA"; # Selection background (color0)
        base03 = "#BCBCBC"; # Comments, invisibles (color8)
        base04 = "#CFCFCF"; # Cark bg highlight (tab_bar_background)
        base05 = "#F2B1D6"; # Default foreground
        base06 = "#F2C6DF"; # Light foreground (color15)
        base07 = "#F2D7E7"; # Lightest foreground
        base08 = "#C74F41"; # Red — variables, errors
        base09 = "#FFB08B"; # Orange — integers, booleans
        base0A = "#D3BF63"; # Yellow — classes
        base0B = "#99AC6C"; # Green — strings
        base0C = "#4D8386"; # Cyan — escape chars, regex
        base0D = "#BE7B7B"; # Blue — functions
        base0E = "#C04F84"; # Magenta — keywords
        base0F = "#FFC9C9"; # Brown — deprecated
        base10 = "#010101"; # Darker background (base00 stepped down)
        base11 = "#000000"; # Darkest background (stepped further)
        base12 = "#F9543E"; # Bright red
        base13 = "#FFFF6C"; # Bright yellow
        base14 = "#CEF17A"; # Bright green
        base15 = "#2CB3BC"; # Bright cyan
        base16 = "#FF8B8B"; # Bright blue
        base17 = "#F451AA"; # Bright magenta
      };
    };

    _file = "scheme.nix";
  };
}
