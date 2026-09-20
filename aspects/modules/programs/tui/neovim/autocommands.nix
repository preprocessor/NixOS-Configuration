{
  exo.mods.neovim = {
    extraConfigLua = /* lua */ ''
      local api = vim.api
      local autocmd = api.nvim_create_autocmd
      local function augroup(name)
        return vim.api.nvim_create_augroup(name, { clear = true })
      end

      -- delete current buffer
      api.nvim_create_user_command('Q', 'bd % <CR>', {})

      vim.cmd([[
        augroup RestoreCursorShapeOnExit
            autocmd!
            autocmd VimLeave * set guicursor=a:ver10-blinkon500-blinkoff500-blinkwait1
        augroup END
      ]])

      local tempdirgroup = augroup('tempdir')
      -- Do not set undofile for files in /tmp
      autocmd('BufWritePre', {
        pattern = '/tmp/*',
        group = tempdirgroup,
        callback = function()
          vim.cmd.setlocal('noundofile')
        end,
      })

      -- Check if we need to reload the file when it changed
      autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
        group = augroup('checktime'),
        callback = function()
          if vim.o.buftype ~= 'nofile' then
            vim.cmd('checktime')
          end
        end,
      })

      -- Highlight on yank
      autocmd('TextYankPost', {
        group = augroup('highlight_yank'),
        callback = function()
          (vim.hl or vim.highlight).on_yank()
        end,
      })

      -- resize splits if window got resized
      autocmd({ 'VimResized' }, {
        group = augroup('resize_splits'),
        callback = function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd('tabdo wincmd =')
          vim.cmd('tabnext ' .. current_tab)
        end,
      })

      -- go to last loc when opening a buffer
      autocmd('BufReadPost', {
        group = augroup('last_loc'),
        callback = function(event)
          local exclude = { 'gitcommit' }
          local buf = event.buf
          if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
          end
          vim.b[buf].lazyvim_last_loc = true
          local mark = vim.api.nvim_buf_get_mark(buf, '"')
          local lcount = vim.api.nvim_buf_line_count(buf)
          if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
          end
        end,
      })

      -- close some filetypes with <q>
      autocmd('FileType', {
        group = augroup('close_with_q'),
        pattern = {
          'PlenaryTestPopup',
          'checkhealth',
          'dbout',
          'gitsigns-blame',
          'grug-far',
          'help',
          'lspinfo',
          'neotest-output',
          'neotest-output-panel',
          'neotest-summary',
          'notify',
          'qf',
          'spectre_panel',
          'startuptime',
          'tsplayground',
        },
        callback = function(event)
          vim.bo[event.buf].buflisted = false
          vim.schedule(function()
            vim.keymap.set('n', 'q', function()
              vim.cmd('close')
              pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
            end, {
              buffer = event.buf,
              silent = true,
              desc = 'Quit buffer',
            })
          end)
        end,
      })

      -- make it easier to close man-files when opened inline
      autocmd('FileType', {
        group = augroup('man_unlisted'),
        pattern = { 'man' },
        callback = function(event)
          vim.bo[event.buf].buflisted = false
        end,
      })

      -- wrap and check for spell in text filetypes
      autocmd('FileType', {
        group = augroup('wrap_spell'),
        pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
        callback = function()
          vim.opt_local.wrap = true
          -- vim.opt_local.spell = true
        end,
      })

      -- Fix conceallevel for json files
      autocmd({ 'FileType' }, {
        group = augroup('json_conceal'),
        pattern = { 'json', 'jsonc', 'json5' },
        callback = function()
          vim.opt_local.conceallevel = 0
        end,
      })

      -- Auto create dir when saving a file, in case some intermediate directory does not exist
      autocmd({ 'BufWritePre' }, {
        group = augroup('auto_create_dir'),
        callback = function(event)
          if event.match:match('^%w%w+:[\\/][\\/]') then
            return
          end
          local file = vim.uv.fs_realpath(event.match) or event.match
          vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
        end,
      })

      -- Disable spell checking in terminal buffers
      local nospell_group = augroup('nospell')
      autocmd('TermOpen', {
        group = nospell_group,
        callback = function()
          vim.wo[0].spell = false
        end,
      })

      -- LSP
      local keymap = vim.keymap

      local function preview_location_callback(_, result)
        if result == nil or vim.tbl_isempty(result) then
          return nil
        end
        local buf, _ = vim.lsp.util.preview_location(result[1])
        if buf then
          local cur_buf = vim.api.nvim_get_current_buf()
          vim.bo[buf].filetype = vim.bo[cur_buf].filetype
        end
      end

      local function peek_definition()
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
      end

      local function peek_type_definition()
        local params = vim.lsp.util.make_position_params()
        return vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
      end

      --- Don't create a comment string when hitting <Enter> on a comment line
      autocmd('BufEnter', {
        group = augroup('DisableNewLineAutoCommentString'),
        callback = function()
          vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
        end,
      })

      local attached_clients = {}

      autocmd('LspAttach', {
        group = augroup('UserLspConfig'),
        callback = function(ev)
          local bufnr = ev.buf
          local client_id = ev.data.client_id
          local client = vim.lsp.get_client_by_id(client_id)

          -- Skip if already attached
          if attached_clients[bufnr] and attached_clients[bufnr][client_id] then
            return
          end

          -- Attach plugins
          -- require('nvim-navic').attach(client, bufnr)

          vim.cmd.setlocal('signcolumn=yes')
          vim.bo[bufnr].bufhidden = 'hide'

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local function desc(description)
            return { noremap = true, silent = true, buffer = bufnr, desc = description }
          end
          keymap.set('n', 'gD', vim.lsp.buf.declaration, desc('lsp [g]o to [D]eclaration'))
          keymap.set('n', 'gd', vim.lsp.buf.definition, desc('lsp [g]o to [d]efinition'))
          keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, desc('lsp [g]o to [t]ype definition'))
          -- keymap.set('n', 'K', vim.lsp.buf.hover, desc('[lsp] hover'))
          keymap.set('n', '<space>pd', peek_definition, desc('lsp [p]eek [d]efinition'))
          keymap.set('n', '<space>pt', peek_type_definition, desc('lsp [p]eek [t]ype definition'))
          keymap.set('n', 'gi', vim.lsp.buf.implementation, desc('lsp [g]o to [i]mplementation'))
          keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, desc('[lsp] signature help'))
          keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, desc('lsp add [w]orksp[a]ce folder'))
          keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, desc('lsp [w]orkspace folder [r]emove'))
          keymap.set('n', '<space>wl', function()
            vim.print(vim.lsp.buf.list_workspace_folders())
          end, desc('[lsp] [w]orkspace folders [l]ist'))
          keymap.set('n', '<space>rn', vim.lsp.buf.rename, desc('lsp [r]e[n]ame'))
          keymap.set('n', '<space>wq', vim.lsp.buf.workspace_symbol, desc('lsp [w]orkspace symbol [q]'))
          keymap.set('n', '<space>dd', vim.lsp.buf.document_symbol, desc('lsp [dd]ocument symbol'))
          keymap.set('n', '<M-CR>', vim.lsp.buf.code_action, desc('[lsp] code action'))
          keymap.set('n', 'gr', vim.lsp.buf.references, desc('lsp [g]et [r]eferences'))
          keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, desc('[lsp] [f]ormat buffer'))
          if client and client.server_capabilities.inlayHintProvider then
            keymap.set('n', '<space>i', function()
              local current_setting = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
              vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
            end, desc('[lsp] toggle inlay hints'))
          end
        end,
      })
    '';

    _file = ./autocommands.nix;
  };
}
