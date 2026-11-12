{
  modules.features.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      extraConfigLua = # lua
        ''
          local function realpath(path)
            return vim.uv.fs_realpath(path) or vim.fn.fnamemodify(path, ":p")
          end
          _G.realpath = realpath

          local function jump(pos)
            pcall(vim.api.nvim_win_set_cursor, 0, pos)
            vim.cmd("normal! zz")
          end

          -- Also called over RPC by other instances.
          _G.nvim_focus_file = function(target, pos)
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              local name = vim.api.nvim_buf_get_name(buf)
              if name ~= "" and vim.bo[buf].buflisted and realpath(name) == target then
                local wins = vim.fn.win_findbuf(buf)
                if #wins > 0 then
                  vim.api.nvim_set_current_win(wins[1])
                else
                  vim.api.nvim_set_current_buf(buf)
                end
                if pos then
                  jump(pos)
                end
                return { found = true, kitty_id = vim.env.KITTY_WINDOW_ID }
              end
            end
            return nil
          end

          local function focus_kitty_window(id)
            if id and id ~= "" then
              pcall(vim.fn.jobstart, { "kitty", "@", "focus-window", "-m", "id:" .. id }, { detach = true })
            end
          end

          _G.focus_if_open_elsewhere = function(path, pos)
            local target = realpath(path)
            local hit = _G.nvim_focus_file(target, pos)
            if hit then
              focus_kitty_window(hit.kitty_id)
              return true
            end

            for _, socket in ipairs(vim.fn.serverlist({ peer = true })) do
              if socket ~= vim.v.servername then
                local ok, chan = pcall(vim.fn.sockconnect, "pipe", socket, { rpc = true })
                if ok and chan > 0 then
                  local req_ok, result = pcall(
                    vim.rpcrequest, chan, "nvim_exec_lua",
                    "return _G.nvim_focus_file(...)",
                    { target, pos }
                  )
                  pcall(vim.fn.chanclose, chan)
                  if req_ok and type(result) == "table" then
                    focus_kitty_window(result.kitty_id)
                    return true
                  end
                end
              end
            end
            return false
          end

          _G.edit_or_focus = function(path, pos)
            if _G.focus_if_open_elsewhere(path, pos) then
              return true
            end
            vim.cmd("edit " .. vim.fn.fnameescape(path))
            if pos then
              jump(pos)
            end
            return false
          end

          -- Kitty helpers
          _G.open_in_kitty = function(file, line, col)
            local nvim = vim.fn.exepath("nvim")
            local cmd = { "kitty", "-1", nvim ~= "" and nvim or "nvim" }
            if line and col then
              table.insert(cmd, string.format("+call cursor(%d, %d)", line, col))
            elseif line then
              table.insert(cmd, "+" .. line)
            end
            table.insert(cmd, vim.fn.fnamemodify(file, ":p"))
            local ok, job = pcall(vim.fn.jobstart, cmd, { detach = true })
            return ok and type(job) == "number" and job > 0
          end

          _G.move_buf_to_kitty = function()
            local buf = vim.api.nvim_get_current_buf()
            local name = vim.api.nvim_buf_get_name(buf)
            if name == "" or vim.bo[buf].buftype ~= "" then
              vim.notify("Nothing to move: not a file buffer", vim.log.levels.WARN)
              return
            end
            if #vim.fn.getbufinfo({ buflisted = 1 }) <= 1 then
              return
            end

            vim.cmd("silent update")
            local pos = vim.api.nvim_win_get_cursor(0)
            if not _G.open_in_kitty(name, pos[1], pos[2] + 1) then
              vim.notify("Failed to open a kitty window", vim.log.levels.WARN)
              return
            end

            if _G.Snacks and Snacks.bufdelete then
              Snacks.bufdelete(buf)
            else
              vim.cmd("bnext | bdelete " .. buf)
            end
          end

          vim.api.nvim_create_user_command("Kedit", function(opts)
            _G.open_in_kitty(opts.args)
          end, { nargs = 1, complete = "file" })

          vim.api.nvim_create_user_command("Kmove", _G.move_buf_to_kitty, {})

          -- Lazygit logic
          _G.LazygitEdit = function(path, line)
            vim.defer_fn(function()
              _G.edit_or_focus(path, line > 0 and { line, 0 } or nil)
            end, 100)
            return 0
          end
        '';

      keymaps = [
        {
          mode = "n";
          key = "M";
          action = "<cmd>lua _G.move_buf_to_kitty()<cr>";
          options = {
            desc = "Move buffer to new kitty window";
            silent = true;
          };
        }
      ];

      plugins.yazi.settings = {
        open_file_function = mkRaw ''
          function(chosen_file)
            _G.edit_or_focus(chosen_file)
          end
        '';
      };

      plugins.snacks.settings.picker =
        let
          confirmKey = (lib.nixvim.listToUnkeyedAttrs [ "focus_or_edit" ]) // {
            mode = [
              "n"
              "i"
            ];
          };
        in
        {
          win = {
            input.keys."<CR>" = confirmKey;
            list.keys."<CR>" = confirmKey;
          };
          actions = {
            focus_or_edit = mkRaw ''
              function(picker, item, action)
                local confirm = require("snacks.picker.actions").confirm
                if not item or not (item.file or item._path) then
                  return confirm(picker, item, action)
                end

                local raw = item._path or item.file
                local target
                if raw:sub(1, 1) == "/" or raw:sub(1, 1) == "~" then
                  target = _G.realpath(vim.fn.fnamemodify(raw, ":p"))
                else
                  local base = item.cwd or picker.cwd or vim.fn.getcwd()
                  target = _G.realpath(vim.fn.fnamemodify(base .. "/" .. raw, ":p"))
                end

                -- Don't leave the picker for its own preview.
                local main_win = picker.main
                if main_win and vim.api.nvim_win_is_valid(main_win) then
                  local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(main_win))
                  if name ~= "" and _G.realpath(name) == target then
                    picker:close()
                    if item.pos then
                      pcall(vim.api.nvim_win_set_cursor, main_win, { item.pos[1], item.pos[2] })
                      vim.api.nvim_win_call(main_win, function() vim.cmd("normal! zz") end)
                    end
                    return
                  end
                end

                if _G.focus_if_open_elsewhere(target, item.pos) then
                  picker:close()
                  return
                end

                return confirm(picker, item, action)
              end
            '';
          };
        };
    };
}
