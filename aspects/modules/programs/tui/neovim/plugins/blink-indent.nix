{
  exo.mods.neovim =
    { lib, ... }:
    {
      plugins.blink-indent.enable = true;

      keymaps = [
        {
          action = lib.nixvim.mkRaw /* lua */ ''
            function() require('blink.indent').enable(not require('blink.indent').is_enabled()) end
          '';
          key = "<leader>ug";
          mode = "n";
          options.desc = "Toggle indent guides";
        }
      ];
    };
}
