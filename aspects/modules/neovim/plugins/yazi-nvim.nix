{
  exo.mods.neovim =
    { lib, ... }:
    {
      globals.loaded_netrwPlugin = 1;

      keymaps = [
        {
          action = lib.nixvim.mkRaw /* lua */ "function() require('yazi').yazi() end";
          key = "<leader>e";
          mode = "n";
          options.desc = "File [E]xplorer (Yazi)";
        }
      ];

      plugins.yazi = {
        enable = true;
        settings = {
          open_for_directories = true;
          floating_window_scaling_factor = 0.8;
          # yazi_floating_window_winblend = 10;
          yazi_floating_window_border = "single";
        };
      };
    };
}
