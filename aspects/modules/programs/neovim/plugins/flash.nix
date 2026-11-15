{
  modules.features.nixvim =
    { lib, ... }:
    let
      inherit (lib.nixvim) mkRaw;
    in
    {
      plugins.flash = {
        enable = true;
        lazyLoad.settings.keys = [
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
