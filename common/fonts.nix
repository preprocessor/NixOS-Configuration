{ inputs, pkgs, ... }:
let
  apple-fonts = inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system};
in {
  fonts.packages = with pkgs; [
    fira-code
    victor-mono
    apple-fonts.sf-pro
    apple-fonts.sf-compact
    apple-fonts.sf-mono
    apple-fonts.ny
  ];
}
