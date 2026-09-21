{
  exo.mods.desktop =
    { wrapPackage, pkgs, ... }:
    {
      nixpkgs.overlays = [
        (_: prev: {
          gum = (
            wrapPackage {
              package = prev.gum;
              env = {
                CLICOLOR_FORCE = 1;
                GUM_CONFIRM_SHOW_HELP = 0;
                GUM_CHOOSE_SHOW_HELP = 0;
                GUM_CHOOSE_HEADER = "";
              };
            }
          );
        })
      ];

      hj.packages = [ pkgs.gum ];
    };
}
