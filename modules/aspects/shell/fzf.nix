{
  flake.modules.homeManager.default =
    { osConfig, lib, ... }:
    let
      scheme = osConfig.scheme;
    in
    {
      programs.fzf = {
        enable = true;
        colors = {
          bg = "#${scheme.base00}";
          "bg+" = "#${scheme.base04}";
          fg = "#${scheme.base05}";
          "fg+" = "#${scheme.green}";
          hl = "#${scheme.red}";
          "hl+" = "#${scheme.red}";
          gutter = "#${scheme.base04}";
          separator = "#${scheme.base04}";
          border = "#${scheme.base04}";
          disabled = "#${scheme.base03}";
          info = "#${scheme.blue}";
          header = "#${scheme.base03}";
          marker = "#${scheme.green}";
          prompt = "#${scheme.green}";
          pointer = "#${scheme.green}";
          spinner = "#${scheme.yellow}";
        };
      };
    };
}
