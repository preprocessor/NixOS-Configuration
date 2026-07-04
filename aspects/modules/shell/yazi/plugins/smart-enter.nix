{
  w.shell =
    { config, pkgs, ... }:
    {
      custom.programs.yazi.initLua = /* lua */ ''
        require("smart-enter"):setup {
          open_multi = true, -- Allow open to target multiple selected files
        }
      '';

      custom.programs.yazi.plugins = {
        inherit (pkgs.yaziPlugins) smart-enter;
      };

      custom.programs.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "l" ] "plugin bypass smart-enter" "Enter the child directory, or open the file")
        ];
      };
    };
}
