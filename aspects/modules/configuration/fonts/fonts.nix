{
  inputs.apple-fonts.url = "github:Lyndeno/apple-fonts.nix"; # Apple's New York & San Francisco fonts
  envoy = {
    chicago-font.github = "nikdog/chicago-font";
    helvetica-font.github = "Kyles-World/Helvetica-Font";
  };

  w.desktop =
    {
      envoy,
      inputs',
      pkgs,
      ...
    }:
    let
      fragment-mono = pkgs.fetchzip {
        url = "https://github.com/weiweihuanghuang/fragment-mono/releases/download/1.21/fragment-mono-1.21.zip";
        hash = "sha256-H5s4rYDN2d0J+zVRgBzg8vfZXCA/jjHrGBV8o8Dxutc=";
      };
    in
    {
      hj.packages = [ pkgs.font-manager ];

      fonts.packages = [
        (pkgs.stdenvNoCC.mkDerivation {
          inherit (envoy.chicago-font) src pname version;
          dontUnpack = true;
          dontBuild = true;
          dontConfigure = true;
          buildCommand = ''install -m444 -Dt $out/share/fonts/truetype "$src/Chicago v0.5.5.ttf"'';
        })

        (pkgs.stdenvNoCC.mkDerivation {
          inherit (envoy.helvetica-font) src pname version;
          dontUnpack = true;
          dontBuild = true;
          dontConfigure = true;
          buildCommand = ''install -m444 -Dt $out/share/fonts/truetype $src/Helvetica\ World\ \(Unicode\)/*.ttf'';
        })

        (pkgs.stdenvNoCC.mkDerivation {
          src = ./.;
          pname = "Matisse-Pro";
          version = "0.1";
          dontUnpack = true;
          dontBuild = true;
          dontConfigure = true;
          buildCommand = "install -m444 -Dt $out/share/fonts/opentype $src/Matisse-Pro.otf";
        })

        (pkgs.stdenvNoCC.mkDerivation {
          src = fragment-mono;
          pname = "fragment-mono";
          version = "0.1";
          dontUnpack = true;
          dontBuild = true;
          dontConfigure = true;
          buildCommand = "install -m444 -Dt $out/share/fonts/truetype $src/fonts/ttf/*.ttf";
        })
      ];

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
