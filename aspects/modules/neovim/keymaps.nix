{
  exo.mods.neovim = {
    extraConfigLua = /* lua */ ''
      local map = vim.keymap.set
      local api = vim.api

      -- quit
      map('n', 'ZZ', '<cmd>confirm xa<cr>')

      -- better up/down
      map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
      map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
      map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
      map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

      -- Resize window using <ctrl> arrow keys
      map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
      map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
      map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
      map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

      -- Move Lines
      map('n', '<A-j>', "<cmd>execute 'move .+' . v:count1<cr>==", { desc = 'Move Down' })
      map('n', '<A-k>', "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = 'Move Up' })
      map('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move Down' })
      map('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move Up' })
      map('v', '<A-j>', ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = 'Move Down' })
      map('v', '<A-k>', ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = 'Move Up' })

      -- buffers
      map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
      map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
      map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
      map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
      map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
      map('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
      map('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })

      -- Clear search on escape
      map({ 'i', 'n', 's' }, '<esc>', function()
        vim.cmd('noh')
        return '<esc>'
      end, { expr = true, desc = 'Escape and Clear hlsearch' })

      -- Clear search, diff update and redraw
      -- taken from runtime/lua/_editor.lua
      map(
        'n',
        '<leader>ur',
        '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>',
        { desc = 'Redraw / Clear hlsearch / Diff Update' }
      )

      -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
      map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
      map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
      map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
      map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
      map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
      map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

      -- Add undo break-points
      map('i', ',', ',<c-g>u')
      map('i', '.', '.<c-g>u')
      map('i', ';', ';<c-g>u')

      -- save file
      map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })

      --keywordprg
      map('n', '<leader>K', '<cmd>norm! K<cr>', { desc = 'Keywordprg' })

      -- better indenting
      map('x', '<', '<gv')
      map('x', '>', '>gv')

      -- commenting
      map('n', 'gco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Below' })
      map('n', 'gcO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = 'Add Comment Above' })

      -- new file
      map('n', '<leader>fn', '<cmd>enew<cr>', { desc = 'New File' })

      -- location list
      map('n', '<leader>xl', function()
        local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
        if not success and err then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end, { desc = 'Location List' })

      -- quickfix list
      map('n', '<leader>xq', function()
        local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
        if not success and err then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end, { desc = 'Quickfix List' })

      map('n', '[q', vim.cmd.cprev, { desc = 'Previous Quickfix' })
      map('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

      -- formatting
      -- map({ "n", "x" }, "<leader>cf", function()
      --   LazyVim.format({ force = true })
      -- end, { desc = "Format" })

      -- diagnostic
      local diagnostic_goto = function(next, severity)
        return function()
          vim.diagnostic.jump {
            count = (next and 1 or -1) * vim.v.count1,
            severity = severity and vim.diagnostic.severity[severity] or nil,
            float = true,
          }
        end
      end
      map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
      map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
      map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
      map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
      map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
      map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
      map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

      -- highlights under cursor
      -- map('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })
      -- map('n', '<leader>uI', function()
      --   vim.treesitter.inspect_tree()
      --   vim.api.nvim_input('I')
      -- end, { desc = 'Inspect Tree' })

      -- Shift + u = redo
      map('n', '<S-U>', ':redo<cr>')
      -- Shift + return = up
      map('n', '<S-CR>', 'k')

      -- Tab and Shift-Tab behavior
      map('n', '<Tab>', '>>_')
      map('n', '<S-Tab>', '<<_')
      map('i', '<S-Tab>', '<c-d>')
      map('i', '<Tab>', '<c-t>')
      map('v', '<Tab>', '>gv')
      map('v', '<S-Tab>', '<gv')

      -- Paste behavior
      map('c', '<C-V>', '<C-r>+')
      map('i', '<C-V>', '<C-r>+')
      map('n', '<S-Insert>', '"+p')
      map('c', '<S-Insert>', '<C-r>+')
      map('i', '<S-Insert>', '<C-r>+')

      -- Reselect the text that has just been pasted, see also https://stackoverflow.com/a/4317090/6064933.
      map('n', 'gp', "printf('`[%s`]', getregtype()[0])", {
        expr = true,
        desc = 'reselect last pasted area',
      })

      -- Use Esc to quit builtin terminal
      map('t', '<Esc>', [[<c-\><c-n>]])

      -- Change text without putting it into the vim register,
      -- see https://stackoverflow.com/q/54255/6064933
      map('n', 'c', '"_c')
      map('n', 'C', '"_C')
      map('n', 'cc', '"_cc')
      map('x', 'c', '"_c')

      -- Replace visual selection with text in register, but not contaminate the register,
      -- see also https://stackoverflow.com/q/10723700/6064933.
      map('x', 'p', '"_c<Esc>p')

      -- keep cursor position after joining
      map('n', 'J', "", {
        desc = 'join line',
        callback = function()
          vim.cmd([[
            normal! mzJ`z
            delmarks z
          ]])
        end,
      })

      map('n', 'gJ', 'mzgJ`z', {
        desc = 'join visual lines',
        callback = function()
          vim.cmd([[
            normal! zmgJ`z
            delmarks z
          ]])
        end,
      })

      -- Keep cursor position after yanking
      map('n', 'y', 'myy')

      api.nvim_create_autocmd('TextYankPost', {
        pattern = '*',
        group = api.nvim_create_augroup('restore_after_yank', { clear = true }),
        callback = function()
          vim.cmd([[
            silent! normal! `y
            silent! delmarks y
          ]])
        end,
      })

      -- Go to the beginning and end of current line in insert mode quickly
      map('i', '<C-A>', '<HOME>')
      map('i', '<C-E>', '<END>')

      -- Go to beginning of command in command-line mode
      map('c', '<C-A>', '<HOME>')

      -- jk/kj to exit insert mode
      map('i', 'jk', '<Esc>')
      map('i', 'kj', '<Esc>')
    '';

    _file = ./keymaps.nix;
  };
}
