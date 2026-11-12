{
  modules.core = { self, ... }: {
    imports = [ self.hjemModules.atuin ];

    my.atuin = {
      enable = true;
      settings = {
        enter_accept = true;
        filter_mode = "session-preload";
        search_mode = "fuzzy";
      };
    };
  };
}
