{
  envoy.fuzzy-search-src.github = "onelocked/fuzzy-search.yazi";

  w.shell =
    {
      config,
      envoy,
      pkgs,
      lib,
      ...
    }:
    let
      fuzzy-search = pkgs.yaziPlugins.mkYaziPlugin {
        inherit (envoy.fuzzy-search-src) pname version;

        src = lib.cleanSourceWith {
          inherit (envoy.fuzzy-search-src) src;
          filter = name: type: (baseNameOf name == "main.lua");
        };
      };
    in
    {
      wrappers.yazi.plugins = {
        inherit fuzzy-search;
      };

      wrappers.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "<S-f>" ] "plugin fuzzy-search -- fd --TL=3" "Fuzzy Find Files")
          (yaziKeymap [
            "g"
            "/"
          ] "plugin fuzzy-search -- rg --TL=3" "Ripgrep Search")
          (yaziKeymap [ "<S-z>" ] "plugin fuzzy-search -- zoxide --TL=3" "Zoxide Search")
        ];
      };

      _file = ./plugins.nix;
    };
}
