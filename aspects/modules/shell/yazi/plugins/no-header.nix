{
  envoy.no-header.github = "onelocked/no-header-prompt.yazi";

  w.shell =
    {
      envoy,
      pkgs,
      lib,
      ...
    }:
    let
      no-header = pkgs.yaziPlugins.mkYaziPlugin {
        inherit (envoy.no-header) pname version;

        src = lib.cleanSourceWith {
          inherit (envoy.no-header) src;
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
