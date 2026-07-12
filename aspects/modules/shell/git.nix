{
  w.default =
    {
      pkgs,
      config,
      constants,
      ...
    }:
    {
      hj.packages = [ pkgs.gh ];

      sops.templates."git-email" = {
        owner = constants.username;
        content = ''
          [user]
            email = ${config.sops.placeholder."email1"}
        '';
      };

      programs.git = {
        enable = true;
        config = {
          include = {
            path = config.sops.templates."git-email".path;
          };
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
          user.name = "wyspr";
          interactive.diffFilter = "delta --color-only";
          init.defaultBranch = "main";
          advice.objectNameWarning = false;
          pull.rebase = true;
          safe.directory = "/tmp";
        };
      };
    };
}
