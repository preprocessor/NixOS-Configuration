{
  w.wyspr-theme = {
    theme = {
      variant = "dark";
      dark = {
        slug = "wyspr-evangelion";
        scheme = "MAGI";
        author = "wyspr";

        base00 = "#111111"; # Default background
        base01 = "#484848"; # Lighter bg / status bars
        base02 = "#6B6B6B"; # Selection background
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
        slug = "wyspr-scp";
        scheme = "FOUNDATION";
        author = "wyspr";

        base00 = "#b89c7a"; # Default background
        base01 = "#a4896a"; # Lighter bg / status bars
        base02 = "#90775b"; # Selection background (color0)
        base03 = "#7b664b"; # Comments, invisibles (color8)
        base04 = "#66543b"; # Dark bg highlight (tab_bar_background)
        base05 = "#1F0F22"; # Default foreground
        base06 = "#180810"; # Light foreground (color15)
        base07 = "#100002"; # Lightest foreground
        base08 = "#cc241d"; # Red — variables, errors
        base09 = "#d65d0e"; # Orange — integers, booleans
        base0A = "#d79921"; # Yellow — classes
        base0B = "#98971a"; # Green — strings
        base0C = "#689d6a"; # Cyan — escape chars, regex
        base0D = "#458588"; # Blue — functions
        base0E = "#b16286"; # Magenta — keywords
        base0F = "#3f0f00"; # Brown — deprecated
        base10 = "#bda382"; # Darker background (base00 stepped down)
        base11 = "#c7af93"; # Darkest background (stepped further)
        base12 = "#9d0006"; # Bright red
        base13 = "#b57614"; # Bright yellow
        base14 = "#79740e"; # Bright green
        base15 = "#427b58"; # Bright blue
        base16 = "#076678"; # Bright magenta
        base17 = "#8f3f71"; # Bright cyan
      };
    };

    _file = ./theme.nix;
  };

}
