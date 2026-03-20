{ inputs, ... }:
{
  flake-file.inputs.worktrunk.url = "github:max-sixty/worktrunk";
  flake.modules.homeManager.default =
    { pkgs, ... }:
    {
      imports = [ inputs.worktrunk.homeModules.default ];

      programs.worktrunk = {
        enable = true;
        enableFishIntegration = true;
      };

      programs.gh.enable = true;

      programs.git = {
        enable = true;
        settings = {
          init.defaultBranch = "main";
        };
      };

      programs.lazygit = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;

        settings = {
          git.pagers = [
            {
              pager = ''${pkgs.delta} --file-style "#74548c" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi --navigate --keep-plus-minus-markers --commit-style="#8eb893"'';
            }
            {
              pager = ''${pkgs.delta} --side-by-side --file-style "#74548c" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi --navigate --keep-plus-minus-markers --commit-style="#8eb893"'';
            }
          ];
        };
      };
    };
}
