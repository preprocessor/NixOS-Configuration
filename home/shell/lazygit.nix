{ ... }:
{
  programs.lazygit = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;

    settings = {
      git.pagers = [
        {
          pager = ''delta --file-style "#74548c" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi --navigate --keep-plus-minus-markers --commit-style="#8eb893"'';
        }
        {
          pager = ''delta --side-by-side --file-style "#74548c" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi --navigate --keep-plus-minus-markers --commit-style="#8eb893"'';
        }
      ];
    };
  };
}
