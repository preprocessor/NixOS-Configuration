{
  tack.inputs.yazi-fuzzy-search = {
    url = "gh:onelocked/fuzzy-search.yazi";
    type = "fetch";
  };

  exo.core =
    {
      packages',
      config,
      ...
    }:
    {
      my.yazi.plugins = { inherit (packages') fuzzy-search; };

      my.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "<S-f>" ] "plugin fuzzy-search -- fd --TL=3" "Fuzzy Find Files")
          (yaziKeymap [ "<S-s>" ] "plugin fuzzy-search -- rg --TL=3" "Ripgrep Search")
          (yaziKeymap [ "<S-z>" ] "plugin fuzzy-search -- zoxide --TL=3" "Zoxide Search")
        ];
      };
    };
}
