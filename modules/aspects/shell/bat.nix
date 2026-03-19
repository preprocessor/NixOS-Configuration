{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      programs.bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batman
        ];
      };
    };
}
