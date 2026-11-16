{
  modules.features.nixvim = {
    plugins = {
      luasnip = {
        enable = true;
        settings.enable_autosnippets = true;
      };
      friendly-snippets.enable = true;
    };
  };
}
