{
  exo.mods.neovim =
    { pkgs, ... }:
    {
      extraPlugins = [ pkgs.vimPlugins.pretty-fold-nvim ];

      extraConfigLua = /* lua */ ''
        require('pretty-fold').setup {
          keep_indentation = false,
          fill_char = '•',
          sections = {
            left = {
              '• ', function() return string.rep('-', vim.v.foldlevel) end, ' •', 'content', '•'
            },
            right = {
              '• ', 'number_of_folded_lines', ': ', 'percentage', ' •••',
            }
          }
        }
      '';
    };
}
