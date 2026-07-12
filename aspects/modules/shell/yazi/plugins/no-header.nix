{ inputs, ... }:
{
  tack.yazi-no-header = {
    url = "gh:onelocked/no-header-prompt.yazi";
    type = "fetch";
  };

  w.shell =
    {
      pkgs,
      lib,
      ...
    }:
    let
      no-header = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "no-header";
        version = "0.67";

        src = lib.cleanSourceWith {
          src = inputs.yazi-no-header;
          filter = name: type: (baseNameOf name == "main.lua");
        };
      };
    in
    {
      my.yazi.initLua = /* lua */ ''
        require("no-header"):setup()
      '';

      my.yazi.plugins = {
        inherit no-header;
      };
    };
}
