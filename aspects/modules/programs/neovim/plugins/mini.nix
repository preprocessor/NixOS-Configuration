{
  modules.features.neovim = {
    plugins.mini = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      mockDevIcons = true;
      modules = {
        icons = { };
        surround = { };
        ai = { };
      };
    };
  };
}
