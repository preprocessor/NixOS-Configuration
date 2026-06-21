{ inputs, ... }:
{
  inputs.yazi-no-header = {
    url = "github:onelocked/no-header-prompt.yazi";
    flake = false;
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
      wrappers.yazi.initLua = /* lua */ ''
        require("no-header"):setup()
      '';

      wrappers.yazi.plugins = {
        inherit no-header;
      };
    };
}
