{
  w.default =
    {
      pkgs,
      config,
      wrappers,
      ...
    }:
    let
      gitWrapped = wrappers.wrappers.git.wrap {
        inherit pkgs;
        settings = {
          init.defaultBranch = "main";
          user = {
            name = "wyspr";
            email = "wyspr@wyspr.xyz";
          };
          pager.diff = pkgs.diffnav;
        };
      };
    in
    {
      hj.packages = with pkgs; [
        gitWrapped
        gh
      ];
    };
}
