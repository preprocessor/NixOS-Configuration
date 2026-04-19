{ lib, ... }:
{
  w.default =
    { pkgs, config, ... }:
    let
      scheme = config.scheme.withHashtag;
    in
    {
      hj.packages = with pkgs; [
        lazygit
        delta
      ];

      programs.fish.functions.lg = ''
        set -x LAZYGIT_NEW_DIR_FILE ${config.hj.xdg.config.directory}/lazygit/newdir
        command lazygit $argv
        if test -f $LAZYGIT_NEW_DIR_FILE
          cd (cat $LAZYGIT_NEW_DIR_FILE)
          rm -f $LAZYGIT_NEW_DIR_FILE
        end
      '';

      hj.xdg.config.files."lazygit/config.yml".text = /* yaml */ ''
        git:
          paging:
            colorArg: always
          pagers:
            - pager: ${lib.getExe pkgs.delta} --commit-style="${scheme.yellow}" --file-style "${scheme.bright-red}" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi
            - pager: ${lib.getExe pkgs.delta} --commit-style="${scheme.yellow}" --file-style "${scheme.bright-red}" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi --side-by-side

        color:
          ui true

          diff-highlight.oldNormal    "red bold"
          diff-highlight.oldHighlight "red bold 52"
          diff-highlight.newNormal    "green bold"
          diff-highlight.newHighlight "green bold 22"

          diff.meta       "11"
          diff.frag       "magenta bold"
          diff.func       "146 bold"
          diff.commit     "yellow bold"
          diff.old        "red bold"
          diff.new        "green bold"
          diff.whitespace "red reverse"
      '';
    };
}
