{
  ff.apple-fonts.url = "github:Lyndeno/apple-fonts.nix"; # Apple's New York & San Francisco fonts

  w.desktop =
    { pkgs, inputs', ... }:
    {
      fonts = {
        packages =
          with pkgs;
          [
            maple-mono.variable
            maple-mono.NF
            font-awesome_6
            inter
            apple-emoji
          ]
          ++ (with inputs'.apple-fonts.packages; [
            sf-pro
            sf-compact
            sf-mono
            ny
          ]);

        enableDefaultPackages = true;

        fontDir.enable = true;

        fontconfig = {
          enable = true;
          antialias = true;
          hinting = {
            enable = true;
            style = "full";
            autohint = false;
          };
          subpixel = {
            rgba = "rgb";
            lcdfilter = "light";
          };
          defaultFonts = {
            serif = [ "New York" ];
            sansSerif = [ "SF Pro" ];
            monospace = [ "SF Mono Regular" ];
            emoji = [ "Noto Color Emoji" ];
          };
        };
      };
    };
}
