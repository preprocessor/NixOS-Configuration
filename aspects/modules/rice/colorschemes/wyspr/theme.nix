{
  w.wyspr-theme = {
    theme = {
      variant = "light";
      light = {
        slug = "wysprlight";
        scheme = "Theme for wyspr";
        author = "wyspr";

        base00 = "#ddb075"; # Default background
        base01 = "#c89d65"; # Lighter bg / status bars
        base02 = "#b48a56"; # Selection background (color0)
        base03 = "#9c7946"; # Comments, invisibles (color8)
        base04 = "#876636"; # Dark bg highlight (tab_bar_background)
        base05 = "#1F0F22"; # Default foreground
        base06 = "#180810"; # Light foreground (color15)
        base07 = "#100002"; # Lightest foreground
        base08 = "#94250c"; # Red — variables, errors (color1)
        base09 = "#cc901e"; # Orange — integers, booleans (color3)
        base0A = "#cea438"; # Yellow — classes (color11)
        base0B = "#376b30"; # Green — strings (color2)
        base0C = "#355d67"; # Cyan — escape chars, regex (color6)
        base0D = "#373c8c"; # Blue — functions (color4)
        base0E = "#4f0061"; # Magenta — keywords (color5)
        base0F = "#3f0f00"; # Brown — deprecated
        base10 = "#e3b67e"; # Darker background (base00 stepped down)
        base11 = "#edc38e"; # Darkest background (stepped further)
        base12 = "#c3432c"; # Bright red (color9)
        base13 = "#d9de44"; # Bright yellow (bell_border / mark2)
        base14 = "#64aa4b"; # Bright green (color10)
        base15 = "#56a4bb"; # Bright blue (color12)
        base16 = "#6c90ce"; # Bright magenta (color13)
        base17 = "#9b4194"; # Bright cyan (color14)

        # base00 = "#F2EB8F"; # Default background
        # base01 = "#BFBA9C"; # Lighter bg / status bars
        # base02 = "#A8A588"; # Selection background (color0)
        # base03 = "#9B977F"; # Comments, invisibles (color8)
        # base04 = "#8E8A6F"; # Dark bg highlight (tab_bar_background)
        # base05 = "#5C4B51"; # Default foreground
        # base06 = "#4D3E43"; # Light foreground (color15)
        # base07 = "#3D3135"; # Lightest foreground
        # base08 = "#9C4E27"; # Red — variables, errors (color1)
        # base09 = "#7F5814"; # Orange — integers, booleans (color3)
        # base0A = "#9B6D18"; # Yellow — classes (color11)
        # base0B = "#788663"; # Green — strings (color2)
        # base0C = "#4A8E7C"; # Cyan — escape chars, regex (color6)
        # base0D = "#1C6470"; # Blue — functions (color4)
        # base0E = "#A31B42"; # Magenta — keywords (color5)
        # base0F = "#654735"; # Brown — deprecated
        # base10 = "#F7F2CF"; # Darker background (base00 stepped down)
        # base11 = "#F2EB8F"; # Darkest background (stepped further)
        # base12 = "#68341A"; # Bright red (color9)
        # base13 = "#7A5512"; # Bright yellow (bell_border / mark2)
        # base14 = "#4E5641"; # Bright green (color10)
        # base15 = "#113F47"; # Bright blue (color12)
        # base16 = "#681A30"; # Bright magenta (color13)
        # base17 = "#2D5B4F"; # Bright cyan (color14)
      };
      dark = {
        slug = "wysprdark";
        scheme = "Theme for wyspr";
        author = "wyspr";

        base00 = "#111111"; # Default background
        base01 = "#484848"; # Lighter bg / status bars
        base02 = "#6B6B6B"; # Selection background (color0)
        base03 = "#B0B0B0"; # Comments, invisibles (color8)
        base04 = "#E8E8E8"; # Dark bg highlight (tab_bar_background)
        base05 = "#EC7420"; # Default foreground
        base06 = "#EE8236"; # Light foreground (color15)
        base07 = "#F08E4A"; # Lightest foreground
        base08 = "#A80808"; # Red — variables, errors (color1)
        base09 = "#EC7420"; # Orange — integers, booleans (color3)
        base0A = "#F4B000"; # Yellow — classes (color11)
        base0B = "#409820"; # Green — strings (color2)
        base0C = "#60F0A0"; # Cyan — escape chars, regex (color6)
        base0D = "#5090C8"; # Blue — functions (color4)
        base0E = "#A06090"; # Magenta — keywords (color5)
        base0F = "#F3505D"; # Brown — deprecated
        base10 = "#0A0A0A"; # Darker background (base00 stepped down)
        base11 = "#000000"; # Darkest background (stepped further)
        base12 = "#F02020"; # Bright red (color9)
        base13 = "#F0F0A0"; # Bright yellow (bell_border / mark2)
        base14 = "#50FF10"; # Bright green (color10)
        base15 = "#40C8E8"; # Bright blue (color12)
        base16 = "#B040A0"; # Bright magenta (color13)
        base17 = "#3CFFD0"; # Bright cyan (color14)
      };
    };

    _file = ./theme.nix;
  };

}
