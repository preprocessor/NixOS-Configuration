{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      plugins.lualine = {
        enable = true;
        lazyLoad.settings.event = [
          "VimEnter"
          "BufReadPost"
          "BufNewFile"
        ];
        settings = {
          options = {
            globalstatus = true;
            extensions = [ "fzf" ];
            disabled_filetypes = {
              statusline = [
                "snacks_dashboard"
                "ministarter"
                "dashboard"
                "alpha"
              ];
            };
            section_separators = {
              left = "";
              right = "";
            };
            component_separators = {
              left = "│";
              right = "│";
            };
          };

          sections = {
            lualine_a = [
              {
                __unkeyed-1 = "mode";
                icon = "";
                fmt = mkRaw /* lua */ ''
                  function(str)
                    return str:sub(1, 3)
                  end
                '';
              }
            ];
            lualine_b = [
              {
                __unkeyed-1 = "branch";
                icon = "";
              }
              {
                __unkeyed-1 = "diff";
                symbols = {
                  added = " ";
                  modified = " ";
                  removed = " ";
                };
                source = mkRaw /* lua */ ''
                  function()
                    local gitsigns = vim.b.gitsigns_status_dict
                    if gitsigns then
                      return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                      }
                    end
                  end
                '';
              }
            ];
            lualine_c = [
              { __unkeyed-1 = "filename"; }
              {
                __unkeyed-1 = "diagnostics";
                sources = [ "nvim_lsp" ];
                symbols = {
                  error = " ";
                  warn = " ";
                  info = " ";
                  hint = "󰝶 ";
                };
              }
              { __unkeyed-1 = "navic"; }
            ];
          };

          lualine_x = [
            { __unkeyed-1 = "encoding"; }
            { __unkeyed-1 = "fileformat"; }
            { __unkeyed-1 = "filetype"; }
            { __unkeyed-1 = mkRaw "require('snacks').profiler.status()"; }
            {
              __unkeyed-1 = mkRaw "function() return require('noice').api.status.command.get() end";
              cond = mkRaw "function() return package.loaded['noice'] and require('noice').api.status.command.has() end";
              color = mkRaw "function() return { fg = require('snacks').util.color('Statement') } end";
            }
            {
              __unkeyed-1 = mkRaw "function() return require('noice').api.status.mode.get() end";
              cond = mkRaw "function() return package.loaded['noice'] and require('noice').api.status.mode.has() end";
              color = mkRaw "function() return { fg = require('snacks').util.color('Constant') } end";
            }
            {
              __unkeyed-1 = mkRaw "function() return '  ' .. require('dap').status() end";
              cond = mkRaw "function() return package.loaded['dap'] and require('dap').status() ~= '' end";
              color = mkRaw "function() return { fg = require('snacks').util.color('Debug') } end";
            }
          ];

          lualine_y = [
            {
              __unkeyed-1 = mkRaw /* lua */ ''
                function()
                  -- recording macros
                  local reg_recording = vim.fn.reg_recording()
                  if reg_recording ~= "" then
                    return " @" .. reg_recording
                  end
                  -- executing macros
                  local reg_executing = vim.fn.reg_executing()
                  if reg_executing ~= "" then
                    return " @" .. reg_executing
                  end
                  -- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
                  local mode = vim.api.nvim_get_mode().mode
                  if mode == "ix" then
                    return "^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)"
                  end
                  return ""
                end
              '';
            }
          ];
          lualine_z = [
            {
              __unkeyed-1 = mkRaw "progress";
              padding = {
                left = 1;
                right = 1;
              };
            }
            {
              __unkeyed-1 = mkRaw "location";
              padding = {
                left = 0;
                right = 1;
              };
            }
          ];
        };
      };
    };
}
