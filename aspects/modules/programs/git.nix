{
  exo.core =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.gh ];

      programs.git = {
        enable = true;
        config = {
          core = {
            editor = "$EDITOR";
            pager = "delta";
            excludesfile = "${pkgs.writeText "gitignore-global" ''
              .envrc
              .direnv
              result*
            ''}";
          };
          merge = {
            conflictStyle = "zdiff3";
          };
          diff = {
            colorMoved = "default";
          };
          pager = {
            diff = "diffnav";
            show = "diffnav";
            log = "diffnav";
          };
          user.name = "preprocessor";
          user.email = "5649544+preprocessor@users.noreply.github.com";
          interactive.diffFilter = "delta --color-only";
          init.defaultBranch = "main";
          advice.objectNameWarning = false;
          pull.rebase = true;
          safe.directory = "/tmp";
        };
      };
    };
}
