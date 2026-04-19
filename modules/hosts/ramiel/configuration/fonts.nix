{ inputs, ... }:
{
  ff.apple-fonts.url = "github:Lyndeno/apple-fonts.nix"; # Apple's New York & San Francisco fonts

  w.ramiel =
    { pkgs, ... }:
    let
      apple-fonts = inputs.apple-fonts.packages.${pkgs.sys};
    in
    {

      fonts.packages = with pkgs; [
        noto-fonts-color-emoji
        maple-mono.variable
        nerd-fonts.jetbrains-mono
        inter
        font-awesome_6

        apple-fonts.sf-pro
        apple-fonts.sf-compact
        apple-fonts.sf-mono
        apple-fonts.ny
      ];

      fonts.enableDefaultPackages = true;
      fonts.fontDir.enable = true;

      fonts.fontconfig = {
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
        defaultFonts.emoji = [ "Noto Color Emoji" ];
      };

      stylix.fonts = {
        serif = {
          package = apple-fonts.ny;
          name = "New York";
        };

        sansSerif = {
          package = apple-fonts.sf-pro;
          name = "SF Pro";
        };

        monospace = {
          package = apple-fonts.sf-mono;
          name = "SF Mono Regular";
        };
      };
    };
}
