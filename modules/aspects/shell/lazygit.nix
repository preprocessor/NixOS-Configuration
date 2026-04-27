{ lib, inputs, ... }:
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

      programs.fish.functions.lg = /* fish */ ''
        set -x LAZYGIT_NEW_DIR_FILE ${config.hj.xdg.config.directory}/lazygit/newdir
        command lazygit $argv
        if test -f $LAZYGIT_NEW_DIR_FILE
          cd (cat $LAZYGIT_NEW_DIR_FILE)
          rm -f $LAZYGIT_NEW_DIR_FILE
        end
      '';

      nixpkgs.overlays = [
        (
          final: prev:
          let
            yamlFormat = prev.formats.yaml { };
          in
          {
            lazygit = inputs.wrappers.lib.wrapPackage {
              pkgs = prev;
              package = prev.lazygit;
              env.LG_CONFIG_FILE = yamlFormat.generate "config.yml" {
                git = {
                  autoFetch = false;
                  overrideGpg = true;
                  paging.colorArg = "always";
                  pagers = [
                    {
                      pager = ''${lib.getExe pkgs.delta} --commit-style="${scheme.yellow}" --file-style "${scheme.bright-red}" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi'';
                    }
                    {
                      pager = ''${lib.getExe pkgs.delta} --commit-style="${scheme.yellow}" --file-style "${scheme.bright-red}" --features space-separated --dark --diff-highlight --true-color always --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" --line-fill-method=ansi --side-by-side'';
                    }
                  ];
                  update = {
                    days = 365;
                    method = "never";
                  };
                };

                color = {
                  ui = true;

                  diff-highlight = {
                    oldNormal = "red bold";
                    oldHighlight = "red bold 52";
                    newNormal = "green bold";
                    newHighlight = "green bold 22";

                  };

                  diff = {
                    meta = "11";
                    frag = "magenta bold";
                    func = "146 bold";
                    commit = "yellow bold";
                    old = "red bold";
                    new = "green bold";
                    whitespace = "red reverse";
                  };
                };

                gui = {
                  expandFocusedSidePanel = true;
                  expandedSidePanelWeight = 2;
                  filterMode = "fuzzy";
                  showBottomLine = false;
                  showNumstatInFilesView = true;
                  showPanelJumps = false;
                  showRandomTip = false;
                  sidePanelWidth = 0.25;
                };

                keybinding = {
                  universal = {
                    jumpToBlock = [
                      "0"
                      "1"
                      "2"
                      "3"
                      "4"
                    ];
                  };
                };

                os = {
                  editInTerminal = true;
                  edit = ''if [ -n "$NVIM" ]; then nvim --server $NVIM --remote-send '<C-\><C-n><cmd>close<cr>' && nvim --server $NVIM --remote {{filename}}; else nvim {{filename}}; fi'';
                  editAtLine = ''if [ -n "$NVIM" ]; then nvim --server $NVIM --remote-send '<C-\><C-n><cmd>close<cr>' && nvim --server $NVIM --remote +{{line}} {{filename}}; else nvim +{{line}} {{filename}}; fi'';
                };
              };
            };
          }
        )
      ];
    };
}
