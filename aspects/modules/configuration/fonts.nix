{
  ff.apple-fonts.url = "github:Lyndeno/apple-fonts.nix"; # Apple's New York & San Francisco fonts

  w.desktop =
    {
      inputs',
      envoy,
      pkgs,
      lib,
      ...
    }:
    {
      custom.gtk.fonts = {
        serif = {
          name = "New York";
          package = inputs'.apple-fonts.packages.ny;
        };

        sans = {
          name = "SF Pro Display";
          package = inputs'.apple-fonts.packages.sf-pro;
        };

        mono = {
          name = "SF Mono Regular";
          package = inputs'.apple-fonts.packages.sf-mono;
        };

        emoji = {
          name = "Blobmoji";
          package = pkgs.noto-fonts-emoji-blob-bin;
        };
      };
    };
}
