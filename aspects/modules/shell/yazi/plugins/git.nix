{
  w.shell =
    { pkgs, ... }:
    {
      wrappers.yazi.initLua = /* lua */ ''
        require("git"):setup {
        	order = 1500, -- Order of status signs showing in the line mode
        }
      '';

      wrappers.yazi.plugins = {
        inherit (pkgs.yaziPlugins) git;
      };

      wrappers.yazi.settings = {
        plugin.prepend_fetchers = [
          {
            group = "git";
            url = "*";
            run = "git";
          }
          {
            group = "git";
            url = "*/";
            run = "git";
          }
        ];
      };
    };
}
