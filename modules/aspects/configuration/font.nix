{ inputs, ... }:
{
  ff.apple-fonts.url = "github:Lyndeno/apple-fonts.nix"; # Apple's New York & San Francisco fonts

  w.desktop =
    { pkgs, ... }:
    let
      apple-fonts = inputs.apple-fonts.packages.${pkgs.sys};
    in
    {
      fonts = {
        packages = with pkgs; [
          maple-mono.variable
          maple-mono.NF
          font-awesome_6
          inter

          apple-fonts.sf-pro
          apple-fonts.sf-compact
          apple-fonts.sf-mono
          apple-fonts.ny
        ];
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
