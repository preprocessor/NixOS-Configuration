{ inputs, ... }:
{
  ff.base16.url = "github:SenchoPens/base16.nix";
  w.desktop =
    { config, ... }:
    {
      imports = [ inputs.base16.nixosModule ];

      _module.args = {
        inherit (config) scheme;
        schemeHash = config.scheme.withHashtag;
      };

    };
  _file = "base16.nix";
}
