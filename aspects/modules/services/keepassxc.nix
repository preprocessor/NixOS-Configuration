{
  exo.mods.desktop =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.keepassxc ];

      my.hyprland.windowrules.keepass = [
        {
          name = "hide keepassxc";
          match.class = "^org.keepassxc.KeePassXC$";
          rules.tag = "+hidden";
        }
      ];
    };
}
