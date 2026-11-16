{
  modules.core =
    { config, pkgs, ... }:
    {
      my.yazi.initLua = /* lua */ ''
        require("smart-enter"):setup {
          open_multi = true, -- Allow open to target multiple selected files
        }
      '';

      my.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "l" ] "plugin bypass smart-enter" "Enter the child directory, or open the file")
        ];
      };
    };
}
