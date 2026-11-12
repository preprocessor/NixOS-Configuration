{
  modules.core =
    {
      pkgs,
      self,
      lib,
      ...
    }:
    {
      imports = [ self.hjemModules.lazygit ];

      my.lazygit = {
        enable = true;

        settings = {
          git = {
            autoFetch = false;
            overrideGpg = true;
            paging.colorArg = "always";
            update = {
              days = 365;
              method = "never";
            };
            diffRenderers = [
              { command = "${lib.getExe pkgs.hunk} pager --transparent-bg"; }
              { command = "${lib.getExe pkgs.hunk} pager --transparent-bg --mode=split"; }
            ];
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
            showNumstatInFilesView = true;
            showPanelJumps = false;
            showRandomTip = false;
            sidePanelWidth = 0.25;
            border = "single";
            mouseEvents = false;
            showBottomLine = false;

            sidePanels = [
              [
                "files"
                "worktrees"
                "submodules"
              ]
              [
                "branches"
                "remotes"
                "tags"
              ]
              [
                "commits"
                "reflog"
                "stash"
              ]
            ];
          };

          keybinding = {
            universal = {
              jumpToBlock = [
                "1"
                "2"
                "3"
              ];
              focusMainView = "4";
            };
          };

          os = {
            editInTerminal = true;
            # edit = ''if [ -n "$NVIM" ]; then nvim --server $NVIM --remote-send '<C-\><C-n><cmd>close<cr>' && nvim --server $NVIM --remote {{filename}}; else nvim {{filename}}; fi'';
            # editAtLine = ''if [ -n "$NVIM" ]; then nvim --server $NVIM --remote-send '<C-\><C-n><cmd>close<cr>' && nvim --server $NVIM --remote +{{line}} {{filename}}; else nvim +{{line}} {{filename}}; fi'';
          };
        };
      };
    };

}
