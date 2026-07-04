{
  w.shell =
    { pkgs, config, ... }:
    {
      custom.programs.yazi.plugins = {
        inherit (pkgs.yaziPlugins) bypass;
      };

      custom.programs.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "h" ] "plugin bypass reverse" "Enter the child directory, or open the file")
        ];
      };
    };
}
