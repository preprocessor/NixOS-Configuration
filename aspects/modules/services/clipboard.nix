{
  modules.core =
    { self', pkgs, ... }:
    {
      hj.packages = [
        self'.packages.cliphist-tui
        self'.packages.cliphist
        pkgs.wl-clipboard
      ];

      systemd.user.services = {
        cliphist-text = {
          description = "Clipboard history service (Text)";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${self'.packages.cliphist}/bin/cliphist store";
            Restart = "on-failure";
          };
        };

        cliphist-image = {
          description = "Clipboard history service (Images)";
          after = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          wantedBy = [ "graphical-session.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${self'.packages.cliphist}/bin/cliphist store";
            Restart = "on-failure";
          };
        };
      };
    };

  modules.host.ramiel =
    { self', lib, ... }:
    {
      my.hyprland.lua.files."keybinds.clipboard".content = /* lua */ ''
        hl.bind("SUPER + V", hl.dsp.exec_cmd('kitty -e ${lib.getExe self'.packages.cliphist-tui}', {size = { 800, 1200}, float = true, center = true}))
      '';
    };
}
