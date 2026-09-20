{
  exo.mods.neovim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      plugins.snacks = {
        enable = true;
        settings = {
          animate.enabled = false;
          indent.enabled = false;
          input.enabled = true;
          notifier.enabled = true;
          scope.enabled = true;
          scroll.enabled = false;
          statuscolumn.enabled = false; # we set this in options.lua
          words.enabled = true;
          bigfile.enabled = true;
          quickfile.enabled = true;
          terminal.enabled = false;
        };
      };
    };
}
