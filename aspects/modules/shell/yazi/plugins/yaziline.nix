{
  envoy.yaziline.github = "llanosrocas/yaziline.yazi";

  w.shell =
    {
      scheme,
      envoy,
      pkgs,
      lib,
      ...
    }:
    let
      yaziline = pkgs.yaziPlugins.mkYaziPlugin {
        inherit (envoy.yaziline) pname version src;
      };
    in
    {
      wrappers.yazi.initLua = /* lua */ ''
        require("yaziline"):setup({
          separator_style = "empty",
          secondary_color = "${scheme.withHashtag.base00}",
          select_symbol = "",
          yank_symbol = "󰆐",
        })
      '';

      wrappers.yazi.plugins = { inherit yaziline; };
    };
}
