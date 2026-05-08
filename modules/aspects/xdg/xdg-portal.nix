{
  w.desktop =
    { lib, ... }:
    let
      inherit (lib) mkForce;
    in
    {
      xdg = {
        portal = {
          enable = true;
          xdgOpenUsePortal = true;
          wlr.enable = false;
          config = {
            common = {
              default = mkForce [ "gnome" ];
              "org.freedesktop.impl.portal.Secret" = mkForce [ "gnome-keyring" ];
              "org.freedesktop.impl.portal.Chooser" = mkForce [ "none" ];
            };
          };
        };
        terminal-exec = {
          enable = true;
          settings = {
            default = [ "kitty.desktop" ];
          };
        };
      };
      environment.sessionVariables = {
        GTK_USE_PORTAL = "1";
      };
    };
}
