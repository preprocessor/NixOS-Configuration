{
  exo.mods.gaming =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.prismlauncher ];

      #
      my.hyprland.windowrules.minecraft = [
        {
          name = "games-workspace-move-steam";
          match.class = "^Minecraft.*";
          rules = {
            workspace = "5 silent";
            content = "game";
            fullscreen = false;
            float = true;
          };
        }
        {
          name = "games-workspace-move-steam";
          match.class = "^org.prismlauncher.prismlauncher$";
          rules = {
            workspace = "5 silent";
            float = true;
          };
        }
      ];
    };
}
