{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.gum ];

      hj.environment.sessionVariables = {
        GUM_CONFIRM_SHOW_HELP = 0;
        GUM_CHOOSE_SHOW_HELP = 0;
        GUM_CHOOSE_HEADER = "";
      };
    };
}
