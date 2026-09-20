{
  exo.mods.neovim =
    { lib, ... }:
    {
      plugins.persistence.enable = true;

      keymaps =
        let
          inherit (lib.nixvim) mkRaw;
        in
        [
          {
            key = "<leader>qs";
            mode = "n";
            action = mkRaw "function() require('persistence').load() end";
            options.desc = "Restore Session";
          }
          {
            key = "<leader>qS";
            mode = "n";
            action = mkRaw ''function() require("persistence").select() end'';
            options.desc = "Select Session";
          }
          {
            key = "<leader>ql";
            mode = "n";
            action = mkRaw ''function() require("persistence").load { last = true } end'';
            options.desc = "Restore Last Session";
          }
          {
            key = "<leader>qd";
            mode = "n";
            action = mkRaw ''function() require("persistence").stop() end'';
            options.desc = "Don't Save Current Session";
          }
        ];
    };
}
