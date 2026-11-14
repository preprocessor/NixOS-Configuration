{
  modules.features.neovim = { lib, ... }: {
    plugins.mini = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      mockDevIcons = true;
      modules = {
        icons = { };
        surround = { };
        ai = { };
      };
    };

    #mini surround
    autoCmd = [
      {
        event = [ "FileType" ];
        pattern = [ "nix" ];
        desc = "Use curly-brace surroundings in Nix files";
        callback =
          # lua
          lib.nixvim.mkRaw ''
            function()
              vim.b.minisurround_config = {
                custom_surroundings = {
                  b = { output = { left = "{", right = "};" } },
                },
              }
            end
          '';
      }
    ];
    #mini surround: auto jump cursor to the last added bracket
    extraConfigLuaPost =
      # lua
      ''
        do
          local surround = require("mini.surround")
          local add = surround.add
          surround.add = function(mode)
            local is_visual = mode == "visual"
            local first_mark = is_visual and "<" or "["
            local second_mark = is_visual and ">" or "]"
            local first = vim.api.nvim_buf_get_mark(0, first_mark)
            local second = vim.api.nvim_buf_get_mark(0, second_mark)
            local changedtick = vim.api.nvim_buf_get_changedtick(0)
            add(mode)
            if vim.api.nvim_buf_get_changedtick(0) == changedtick then
              return
            end
            local cursor = vim.api.nvim_win_get_cursor(0)
            local left_len = cursor[2] - first[2]
            local target_col = second[2] + 1
            if second[1] == first[1] then
              target_col = target_col + left_len
            end
            vim.api.nvim_win_set_cursor(0, { second[1], target_col })
          end
        end
      '';
  };
}
