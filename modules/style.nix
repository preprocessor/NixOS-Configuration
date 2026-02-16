{ inputs, config, pkgs, ... }:
{
  config.stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-soft.yaml";
    autoEnable = true;
    targets = {
      gtk.enable = true;
      gnome.enable = true;
    };
  };
}
