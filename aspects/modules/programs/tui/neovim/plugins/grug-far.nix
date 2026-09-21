{
  exo.mods.neovim =
    { lib, ... }:
    {
      plugins.grug-far = {
        enable = true;
        lazyLoad.settings.keys = [
          {
            __unkeyed-1 = "<leader>sr";
            __unkeyed-2 = lib.nixvim.mkRaw ''
              function()
                local grug = require("grug-far")
                local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                grug.open({ transient = true, prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil, }, })
              end
            '';
            mode = [
              "n"
              "x"
            ];
            desc = "Search and Replace";
          }
        ];
        settings.headerMaxWidth = 80;
      };
    };
}
