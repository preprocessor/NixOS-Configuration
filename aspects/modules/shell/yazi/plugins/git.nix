{
  w.shell =
    { pkgs, ... }:
    {
      custom.programs.yazi.initLua = /* lua */ ''
        require("git"):setup {
        	order = 1500, -- Order of status signs showing in the line mode
        }
      '';

      custom.programs.yazi.plugins = {
        inherit (pkgs.yaziPlugins) git;
      };

      custom.programs.yazi.settings = {
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
