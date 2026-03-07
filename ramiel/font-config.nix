{ pkgs, ... }:
{
  fonts = {
    # packages = with pkgs; [
    #   apple-nerd-fonts
    #   material-symbols
    #   nerd-fonts.symbols-only
    #   noto-fonts
    #   noto-fonts-color-emoji
    # ];
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
      # defaultFonts = {
      #   serif = [ "SF Pro Display" ];
      #   sansSerif = [ "SF Pro Text" ];
      #   monospace = [ "LigaSFMono Nerd Font" ];
      #   emoji = [ "Noto Color Emoji" ];
      # };
    };
  };
}
