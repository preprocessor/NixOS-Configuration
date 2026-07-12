{ inputs, ... }:
{
  tack.yazi-fuzzy-search = {
    url = "gh:onelocked/fuzzy-search.yazi";
    type = "fetch";
  };

  w.shell =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      fuzzy-search = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "onelocks-fuzzy-zox";
        version = "4.20";

        src = lib.cleanSourceWith {
          src = inputs.yazi-fuzzy-search;
          filter = name: type: (baseNameOf name == "main.lua");
        };
      };
    in
    {
      my.yazi.plugins = {
        inherit fuzzy-search;
      };

      my.yazi.keymap = {
        mgr.prepend_keymap = with config.utils; [
          (yaziKeymap [ "<S-f>" ] "plugin fuzzy-search -- fd --TL=3" "Fuzzy Find Files")
          (yaziKeymap [ "<S-s>" ] "plugin fuzzy-search -- rg --TL=3" "Ripgrep Search")
          (yaziKeymap [ "<S-z>" ] "plugin fuzzy-search -- zoxide --TL=3" "Zoxide Search")
        ];
      };

      _file = ./plugins.nix;
    };
}
