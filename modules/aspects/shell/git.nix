{ inputs, ... }:
{
  flake-file.inputs.fish-completion-sync = {
    url = "github:iynaix/fish-completion-sync";
    flake = false;
  };

  flake.modules.nixos.default =
    { pkgs, config, ... }:
    let
      gitWrapped = inputs.wrappers.wrappers.git.wrap {
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
