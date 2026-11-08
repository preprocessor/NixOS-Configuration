{
  exo.mods.neovim =
    { pkgs, mkRaw, ... }:
    let
      lazygitConfig = ./lazygit.yml;
    in
    {
      extraPackages = [ pkgs.lazygit ];
      extraPlugins = [ pkgs.vimPlugins.lazygit-nvim ];
      plugins.lz-n.plugins = [
        {
          __unkeyed-1 = "lazygit.nvim";
          cmd = [
            "LazyGit"
            "LazyGitCurrentFile"
            "LazyGitFilter"
            "LazyGitFilterCurrentFile"
          ];
        }
      ];

      extraConfigLua = # lua
        ''
          local M = {}

          local state = {
            buf = nil,
            win = nil,
            width = 55,
            attaching = false,
          }

          local function valid_buf(buf)
            return buf ~= nil and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf)
          end

          local function win_for_buf_in_current_tab(buf)
            if not valid_buf(buf) then return nil end
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              if vim.api.nvim_win_get_buf(win) == buf then return win end
            end
            return nil
          end

          local function current_diffview()
            local ok, lib = pcall(require, 'diffview.lib')
            if not ok then return nil end

            local view = lib.get_current_view()
            if not view or not view:is_cur_tabpage() then return nil end

            local ok_view, DiffView = pcall(function()
              return require('diffview.scene.views.diff.diff_view').DiffView
            end)
            if not ok_view or not view:instanceof(DiffView) then return nil end

            return view
          end

          local function resolve_cwd()
            local view = current_diffview()
            if view and view.adapter and view.adapter.ctx then
              return view.adapter.ctx.toplevel
            end

            local bufname = vim.api.nvim_buf_get_name(0)
            local is_path = bufname ~= "" and not bufname:match('^%a[%w+.-]*://')
            local buf_dir = is_path and vim.fn.fnamemodify(bufname, ':p:h') or nil

            if buf_dir and vim.fn.isdirectory(buf_dir) == 1 then
              local root = vim.fn.systemlist(
                'git -C ' .. vim.fn.shellescape(buf_dir) .. ' rev-parse --show-toplevel'
              )[1]
              if root and vim.v.shell_error == 0 then return root end
              return buf_dir
            end

            return vim.fn.getcwd()
          end

          local function close_diffview()
            pcall(vim.cmd, 'DiffviewClose')
          end

          local function start_lazygit(win)
            local buf = vim.api.nvim_create_buf(false, true)
            state.buf = buf

            vim.bo[buf].bufhidden = 'hide'
            vim.bo[buf].swapfile = false
            vim.api.nvim_win_set_buf(win, buf)

            -- lazygit's custom commands need to talk back to this nvim instance.
            local env = vim.fn.environ()
            env.NVIM = vim.v.servername
            env.LG_CONFIG_FILE = '${lazygitConfig}'

            local ok, job = pcall(vim.fn.jobstart, { 'lazygit' }, {
              term = true,
              buf = buf,
              cwd = vim.fn.getcwd(),
              env = env,
              on_exit = function(_, code)
                state.buf = nil
                state.win = nil
                if code == 0 then
                  vim.schedule(close_diffview)
                end
              end,
            })

            if not ok or job <= 0 then
              state.buf = nil
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
              vim.notify('LazyDiff: failed to start lazygit', vim.log.levels.ERROR)
              return false
            end

            return true
          end

          local function focus_lazygit(win)
            state.win = win

            vim.wo[win].winfixwidth = true
            vim.wo[win].number = false
            vim.wo[win].relativenumber = false
            vim.wo[win].signcolumn = 'no'
            vim.wo[win].foldcolumn = '0'
            vim.wo[win].wrap = false

            vim.api.nvim_set_current_win(win)
            if valid_buf(state.buf) and vim.bo[state.buf].buftype == 'terminal' then
              vim.cmd('startinsert')
            end
          end

          local function attach_lazygit()
            if state.attaching or not current_diffview() then return end

            local win = win_for_buf_in_current_tab(state.buf)

            if not win then
              state.attaching = true
              local ok, err = pcall(function()
                vim.cmd('topleft ' .. state.width .. 'vsplit')
                win = vim.api.nvim_get_current_win()

                if valid_buf(state.buf) then
                  vim.api.nvim_win_set_buf(win, state.buf)
                elseif not start_lazygit(win) then
                  win = nil
                end
              end)
              state.attaching = false

              if not ok then
                vim.notify('LazyDiff: ' .. tostring(err), vim.log.levels.ERROR)
                return
              end
            end

            if not win or not vim.api.nvim_win_is_valid(win) or not valid_buf(state.buf) then
              return
            end

            focus_lazygit(win)
          end

          function M.open(args)
            args = args or ""
            local cwd = resolve_cwd()

            vim.schedule(function()
              if cwd and cwd ~= "" then
                vim.cmd('lcd ' .. vim.fn.fnameescape(cwd))
              end

              close_diffview()

              local ok, err = pcall(vim.cmd, 'DiffviewOpen ' .. args)
              if not ok then
                vim.notify('LazyDiff: ' .. tostring(err), vim.log.levels.ERROR)
              end
            end)

            return ""
          end

          function M.close()
            local buf = state.buf
            state.buf = nil
            state.win = nil

            close_diffview()

            if valid_buf(buf) then
              local job = vim.b[buf].terminal_job_id
              if job and job > 0 then pcall(vim.fn.jobstop, job) end
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
          end

          vim.api.nvim_create_autocmd('User', {
            pattern = 'DiffviewViewOpened',
            callback = function()
              vim.schedule(attach_lazygit)
            end,
          })

          setmetatable(M, {
            __call = function(_, args)
              return M.open(args)
            end,
          })

          _G.LazyDiff = M
        '';

      keymaps = [
        {
          mode = "n";
          key = "<leader>gg";
          action = mkRaw ''
            function()
              _G.LazyDiff.open()
            end
          '';
          options = {
            desc = "LazyGit + Diffview";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>gq";
          action = mkRaw ''
            function()
              _G.LazyDiff.close()
            end
          '';
          options = {
            desc = "Close LazyGit + Diffview";
            silent = true;
            noremap = true;
          };
        }
        {
          mode = "n";
          key = "<leader>gl";
          action = "<cmd>LazyGitFilterCurrentFile<cr>";
          options = {
            desc = "Lazygit Current File History";
            silent = true;
            noremap = true;
          };
        }
      ];
    };
}
