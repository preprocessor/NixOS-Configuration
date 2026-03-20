{
  flake.modules.nixos.desktop = {
    programs.steam = {
      enable = true;
    };
  };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        prismlauncher
        runelite
        dualsensectl
      ];
    };
}
