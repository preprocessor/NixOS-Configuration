{
  exo.mods.neovim =
    { lib, ... }:
    {
      plugins.blink-indent = {
        enable = true;
        lazyLoad.settings.event = [
          "BufReadPost"
          "BufNewFile"
        ];
      };

      keymaps = [
        {
          action = lib.nixvim.mkRaw /* lua */ ''
            function()
              local blink = require('blink.indent')
              blink.enable(not blink.is_enabled())
            end
          '';
          key = "<leader>ug";
          mode = "n";
          options.desc = "Toggle indent guides";
        }
      ];
    };
}
