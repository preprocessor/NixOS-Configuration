{
  w.default =
    {
      pkgs,
      config,
      birdee,
      ...
    }:
    let
      gitWrapped = birdee.wrappers.git.wrap {
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
