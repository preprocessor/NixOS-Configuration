{
  ff.hyprland = {
    url = "github:hyprwm/Hyprland";
    inputs = {
      nixpkgs.follows = "nixpkgs";
    };
  };

  perSystem =
    { inputs', ... }:
    {
      packages = {
        hyprland = inputs'.hyprland.packages.default;
        xdg-desktop-portal-hyprland = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
      };
    };

  w.default =
    # { wrappers, ... }:
    {
      lib,
      self',
      inputs',
      ...
    }:
    {

      programs.hyprland = {
        enable = true;
        package = self'.packages.hyprland;
        portalPackage = self'.packages.xdg-desktop-portal-hyprland;
      };

      xdg.portal = {
        config = {
          hyprland = {
            default = lib.mkForce [
              "hyprland"
              "gtk"
            ];
            "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "termfilechooser" ];
            "org.freedesktop.impl.portal.Secret" = lib.mkForce [ "gnome-keyring" ];
            "org.freedesktop.impl.portal.Chooser" = lib.mkForce [ "none" ];
          };
        };
      };

      # options.programs.hyprland.luaFiles = lib.mkForce lib.mkOption {
      #
      # };
      #
      # config = { };
    };
}
