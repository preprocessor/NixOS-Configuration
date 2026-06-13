{
  ff.apple-fonts.url = "github:Lyndeno/apple-fonts.nix"; # Apple's New York & San Francisco fonts
  envoy = {
    chicago-font.github = "nikdog/chicago-font";
    helvetica-font.github = "Kyles-World/Helvetica-Font";
  };

  w.desktop =
    {
      envoy,
      self',
      pkgs,
      ...
    }:
    {
      fonts.packages = [
        (pkgs.stdenv.mkDerivation {
          inherit (envoy.chicago-font) src pname version;
          doCheck = false;
          buildCommand = ''install -m444 -Dt $out/share/fonts/truetype "$src/Chicago v0.5.5.ttf"'';
        })
        (pkgs.stdenv.mkDerivation {
          inherit (envoy.helvetica-font) src pname version;
          doCheck = false;
          buildCommand = ''install -m444 -Dt $out/share/fonts/truetype $src/Helvetica\ World\ \(Unicode\)/*.ttf'';
        })
      ];

      custom.gtk.fonts = {
        serif = {
          name = "New York";
          package = self'.packages.apple-font;
        };

        sans = {
          name = "SF Pro Display";
          package = self'.packages.apple-font;
        };

        mono = {
          name = "SF Mono Regular";
          package = self'.packages.apple-font;

        };

        emoji = {
          name = "Blobmoji";
          package = self'.packages.apple-font;
        };
      };
    };
}
