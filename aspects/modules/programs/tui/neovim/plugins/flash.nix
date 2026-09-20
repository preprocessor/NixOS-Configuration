{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      plugins.flash.enable = true;

      keymaps = [
        {
          key = "s";
          action = mkRaw /* lua */ ''
            function() require('flash').treesitter() end
          '';
          options.desc = "flash treesitter";
        }
        {
          key = "<c-s>";
          action = mkRaw /* lua */ ''
            function() require('flash').toggle() end
          '';
          options.desc = "toggle flash search";
        }
        {
          key = "gm";
          action = mkRaw /* lua */ ''
            function() require('flash').jump { pattern = vim.fn.expand('<cword>') } end
          '';
          options.desc = "word mentions (flash)";
        }
      ];
    };
}
