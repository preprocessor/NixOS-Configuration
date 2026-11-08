{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      plugins.flash = {
        enable = true;
        lazyLoad.settings.keys = [
          {
            __unkeyed-1 = "s";
            __unkeyed-2 = mkRaw /* lua */ ''
              function() require('flash').treesitter() end
            '';
            desc = "flash treesitter";
          }
          {
            __unkeyed-1 = "<c-s>";
            __unkeyed-2 = mkRaw /* lua */ ''
              function() require('flash').toggle() end
            '';
            desc = "toggle flash search";
          }
          {
            __unkeyed-1 = "gm";
            __unkeyed-2 = mkRaw /* lua */ ''
              function() require('flash').jump { pattern = vim.fn.expand('<cword>') } end
            '';
            desc = "word mentions (flash)";
          }
        ];
      };
    };
}
