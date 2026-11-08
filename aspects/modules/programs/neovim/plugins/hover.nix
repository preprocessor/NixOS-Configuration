{
  exo.mods.neovim =
    { pkgs, ... }:
    {
      extraPlugins = [ pkgs.vimPlugins.hover-nvim ];

      extraConfigLua = /* lua */ ''
        require('hover').config({
          providers = {
            'hover.providers.diagnostic',
            'hover.providers.lsp',
            'hover.providers.dap',
            'hover.providers.man',
            'hover.providers.dictionary',
            -- Optional, disabled by default:
            'hover.providers.gh',
            'hover.providers.gh_user',
            -- 'hover.providers.fold_preview',
            -- 'hover.providers.highlight',
          },
        })

        -- Setup keymaps
        vim.keymap.set('n', 'K', function()
          require('hover').open()
        end, { desc = 'hover.nvim (open)' })

        vim.keymap.set('n', 'gK', function()
          require('hover').enter()
        end, { desc = 'hover.nvim (enter)' })

        vim.keymap.set('n', '<C-j>', function()
            require('hover').switch('previous')
        end, { desc = 'hover.nvim (previous source)' })

        vim.keymap.set('n', '<C-l>', function()
            require('hover').switch('next')
        end, { desc = 'hover.nvim (next source)' })

      '';
    };
}
