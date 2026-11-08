{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      plugins.hop = {
        enable = true;
        settings = {
          keys = "etovxqpdygfblzhckisuran";
          create_hl_autocmd = false;
        };
      };

      keymaps = [
        {
          mode = [
            "n"
            "x"
            "o"
          ];
          key = "s";
          action = mkRaw /* lua */ ''
            function()
              vim.cmd('HopWordMW')
            end
          '';
          options.desc = "Hop to word";
        }
        {
          mode = [
            "n"
            "x"
            "o"
          ];
          key = "t";
          action = mkRaw /* lua */ ''
            function()
              require('hop').hint_words {
                direction = require('hop.hint').HintDirection.AFTER_CURSOR,
                multi_windows = true,
              }
            end
          '';
          options = {
            desc = "Hop to word (After cursor)";
            remap = true;
          };
        }
        {
          mode = [
            "n"
            "x"
            "o"
          ];
          key = "T";
          action = mkRaw /* lua */ ''
            function()
              require('hop').hint_words {
                direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
                multi_windows = true,
              }
            end
          '';
          options = {
            desc = "Hop to word (Before cursor)";
            remap = true;
          };
        }
        {
          mode = [
            "n"
            "x"
            "o"
          ];
          key = "gl";
          action = mkRaw /* lua */ ''
            function()
              require('hop').hint_lines_skip_whitespace {
                direction = require('hop.hint').HintDirection.AFTER_CURSOR,
                multi_windows = true,
              }
            end
          '';
          options.desc = "Hop to line (After cursor)";
        }
        {
          mode = [
            "n"
            "x"
            "o"
          ];
          key = "gL";
          action = mkRaw /* lua */ ''
            function()
              require('hop').hint_lines_skip_whitespace {
                direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
                multi_windows = true,
              }
            end
          '';
          options.desc = "Hop to line (Before cursor)";
        }
      ];
    };
}
