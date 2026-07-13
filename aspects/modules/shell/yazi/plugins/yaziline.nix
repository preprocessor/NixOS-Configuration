{ inputs, ... }:
{
  tack.yaziline = {
    url = "gh:llanosrocas/yaziline.yazi";
    type = "fetch";
  };

  exo.core =
    {
      scheme,
      pkgs,
      ...
    }:
    let
      yaziline = pkgs.yaziPlugins.mkYaziPlugin {
        src = inputs.yaziline;
        pname = "yaziline";
        version = "git";
      };
    in
    {
      my.yazi.initLua = /* lua */ ''
        require("yaziline"):setup({
          separator_style = "empty",
          secondary_color = "${scheme.withHashtag.base00}",
          select_symbol = "",
          yank_symbol = "󰆐",
        })
      '';

      my.yazi.plugins = { inherit yaziline; };
    };
}
