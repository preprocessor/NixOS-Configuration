{
  exo.mods.neovim =
    { lib, ... }:
    {
      plugins.grug-far = {
        enable = true;
        settings.headerMaxWidth = 80;
      };

      keymaps = [
        {
          key = "<leader>sr";
          action = lib.nixvim.mkRaw /* lua */ ''
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
          options.desc = "Search and Replace";
        }
      ];
    };
}
