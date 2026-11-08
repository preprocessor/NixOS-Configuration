{
  exo.mods.neovim = {
    plugins.persistence = {
      enable = true;
      lazyLoad.settings.event = "BufReadPre";
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>Sl";
        action.__raw = "function() require('persistence').load() end";
        options.desc = "Load the session for the current directory";
      }
      {
        mode = "n";
        key = "<leader>Ss";
        action.__raw = "function() require('persistence').select() end";
        options.desc = "Select a session to load";
      }
      {
        mode = "n";
        key = "<leader>SL";
        action.__raw = "function() require('persistence').load({ last = true }) end";
        options.desc = "Load the last session";
      }
      {
        mode = "n";
        key = "<leader>SS";
        action.__raw = "function() require('persistence').stop() end";

        options.desc = "Don't Save Current Session";
      }
    ];
  };
}
