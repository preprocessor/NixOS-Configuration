{
  flake.modules.nixos.desktop = {
    programs.steam = {
      enable = true;
    };
  };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      programs.obs-studio.enable = true;

      home.packages = with pkgs; [
        prismlauncher
        runelite
        dualsensectl
      ];
    };
}
