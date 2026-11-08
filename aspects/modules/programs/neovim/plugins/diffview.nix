{
  tack.inputs.diffview-plus = {
    url = "gh:dlyongemallo/diffview-plus.nvim/ba05af7a295dcd8449bd03ebb3aead8268a5c379"; # NOTE: pinned rev because rev 22a293181f6132d175efbbf279c251d7f01d1e8b breaks folding for me in file history
    type = "fetch";
  };

  exo.mods.neovim =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      plugins.diffview = {
        enable = true;
        package = pkgs.vimPlugins.diffview-plus-nvim.overrideAttrs (_: {
          version = inputs._meta.diffview-plus.rev;
          src = inputs.diffview-plus;
        });
      };

      extraConfigLua = # lua
        ''
          vim.opt.diffopt:append({ "algorithm:histogram", "indent-heuristic", })

          local function diffview_hl()
            local set = vim.api.nvim_set_hl

            set(0, 'DiffviewOldLine', { bg = '#2D0000' })
            set(0, 'DiffviewOldText', { bg = '#5C0A0A' })
            set(0, 'DiffviewNewLine', { bg = '#00230C' })
            set(0, 'DiffviewNewText', { bg = '#06471F' })

            -- filler lines (the empty space opposite an add/delete)
            set(0, 'DiffviewFiller', { fg = '#2a2a33', bg = '#16161a' })
          end

          diffview_hl()
          vim.api.nvim_create_autocmd('ColorScheme', { callback = diffview_hl })

          require('diffview').setup({
            enhanced_diff_hl = true,
            use_icons = true,
            view = {
              default = { layout = 'diff2_horizontal' },
              merge_tool = { layout = 'diff3_horizontal' },
            },
            file_panel = {
              listing_style = 'tree',
              win_config = { position = 'left', width = 35 },
            },
            hooks = {
              -- attach treesitter so diff buffers keep syntax highlighting
              diff_buf_read = function(bufnr)
                pcall(vim.treesitter.start, bufnr)
              end,

              diff_buf_win_enter = function(bufnr, winid, ctx)
                vim.wo[winid].number = true
                vim.wo[winid].relativenumber = false
                -- no forced centring inside diffs (overrides global scrolloff = 999)
                vim.wo[winid].scrolloff = 5
                vim.wo[winid].wrap = true

                if not ctx.layout_name:match('^diff2') then return end
                if ctx.symbol == 'a' then -- old / left
                  vim.wo[winid].winhl = table.concat({
                    'DiffAdd:DiffviewOldLine',
                    'DiffDelete:DiffviewFiller',
                    'DiffChange:DiffviewOldLine',
                    'DiffText:DiffviewOldText',
                  }, ',')
                elseif ctx.symbol == 'b' then -- new / right
                  vim.wo[winid].winhl = table.concat({
                    'DiffAdd:DiffviewNewLine',
                    'DiffDelete:DiffviewFiller',
                    'DiffChange:DiffviewNewLine',
                    'DiffText:DiffviewNewText',
                  }, ',')
                end
              end,

              -- start with the file panel closed (toggle it back with your panel key)
              view_opened = function(view)
                -- only for regular diff views, leave the file history log panel alone
                local ok, DiffView = pcall(function()
                  return require('diffview.scene.views.diff.diff_view').DiffView
                end)
                if not (ok and view:instanceof(DiffView)) then return end

                vim.schedule(function()
                  pcall(function() view.panel:close() end)
                end)
              end,
            },
          })
          -- make diffview close with regular :q
          local function diffview_close_abbrev(lhs, replacement)
            if vim.fn.getcmdtype() ~= ':' then return lhs end
            if vim.trim(vim.fn.getcmdline()) ~= lhs then return lhs end

            local ok, lib = pcall(require, 'diffview.lib')
            if not ok or not lib.get_current_view() then return lhs end

            return replacement
          end

          -- :wq needs to write the current buffer before closing, unlike :q.
          pcall(vim.api.nvim_del_user_command, 'DiffviewWriteAndClose')
          vim.api.nvim_create_user_command('DiffviewWriteAndClose', function(opts)
            local ok, lib = pcall(require, 'diffview.lib')
            if not ok or not lib.get_current_view() then
              vim.cmd(opts.bang and 'wq!' or 'wq')
              return
            end

            local bufnr = vim.api.nvim_get_current_buf()
            if vim.bo[bufnr].modified then
              vim.cmd(opts.bang and 'write!' or 'write')
            end

            vim.cmd(opts.bang and 'DiffviewClose!' or 'DiffviewClose')
          end, { bang = true })

          function _G.__diffview_q_abbrev() return diffview_close_abbrev('q', 'DiffviewClose') end
          function _G.__diffview_wq_abbrev() return diffview_close_abbrev('wq', 'DiffviewWriteAndClose') end

          vim.cmd([[
            cnoreabbrev <expr> q  v:lua.__diffview_q_abbrev()
            cnoreabbrev <expr> wq v:lua.__diffview_wq_abbrev()
          ]])
        '';

      keymaps = [
        {
          mode = "n";
          key = "<leader>gd";
          action = ":DiffviewOpen<CR>";
          options = {
            desc = "Diffview Open";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>gD";
          action = ":DiffviewClose<CR>";
          options = {
            desc = "Diffview Close";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>gh";
          action = ":DiffviewFileHistory %<CR>";
          options = {
            desc = "Diffview File History (current file)";
            silent = true;
            noremap = true;
          };
        }
      ];
    };
}
