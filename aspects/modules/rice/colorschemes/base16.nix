{ inputs, ... }:
{
  ff.base16.url = "github:SenchoPens/base16.nix";

  envoy.schemes.github = "tinted-theming/schemes";
  # Browse themes at: https://tinted-theming.github.io/tinted-gallery/

  w.desktop =
    { config, ... }:
    {
      imports = [ inputs.base16.nixosModule ];

      _module.args = {
        inherit (config) scheme;
      };

      _file = ./base16.nix;
    };
}
