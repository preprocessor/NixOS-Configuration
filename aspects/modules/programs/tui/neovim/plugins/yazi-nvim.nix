{
  exo.mods.neovim = {
    globals.loaded_netrwPlugin = 1;

    keymaps = [
      {
        action = "<CMD>Yazi<CR>";
        key = "<leader>e";
        mode = "n";
        options.desc = "File [E]xplorer (Yazi)";
      }
    ];

    plugins.yazi = {
      enable = true;
      lazyLoad.settings.cmd = [ "Yazi" ];
      settings = {
        open_for_directories = true;
        floating_window_scaling_factor = 0.8;
        # yazi_floating_window_winblend = 10;
        yazi_floating_window_border = "single";
      };
    };
  };
}
