{ inputs, ... }:
{
  ff.base16.url = "github:SenchoPens/base16.nix";
  w.desktop.imports = [ inputs.base16.nixosModule ];
}
