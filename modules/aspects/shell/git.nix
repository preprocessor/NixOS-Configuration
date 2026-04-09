{ lib, ... }:
{
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.worktrunk ];
      programs.fish.interactiveShellInit = ''
        ${lib.getExe pkgs.worktrunk} config shell init fish | source
      '';

      programs.gh.enable = true;

      programs.git = {
        enable = true;
        settings = {
          init.defaultBranch = "main";
          user = {
            name = "wyspr";
            email = "wyspr@wyspr.xyz";
          };
        };
      };

      programs.delta = {
        enable = true;
        enableGitIntegration = true;
      };

      programs.lazygit = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;

        settings = {
          git.pagers = [
            {
              pager = ''${lib.getExe pkgs.delta} --file-style "#74548c" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi --navigate --keep-plus-minus-markers --commit-style="#8eb893"'';
            }
            {
              pager = ''${lib.getExe pkgs.delta} --side-by-side --file-style "#74548c" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi --navigate --keep-plus-minus-markers --commit-style="#8eb893"'';
            }
          ];
        };
      };
    };
}
