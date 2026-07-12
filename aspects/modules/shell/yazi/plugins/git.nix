{
  w.shell =
    { pkgs, ... }:
    {
      my.yazi.initLua = /* lua */ ''
        require("git"):setup {
        	order = 1500, -- Order of status signs showing in the line mode
        }
      '';

      my.yazi.plugins = {
        inherit (pkgs.yaziPlugins) git;
      };

      my.yazi.settings = {
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
