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
      fragment-mono = pkgs.fetchFromGitHub {
        owner = "dtinth";
        repo = "fragment-mono-weights";
        rev = "ab47063dc6b2d2040071173ce87ec84d6d5997ed";
        hash = "sha256-TF0LW+4axEQvmNRvRL7zZACkALA7SgM2EKZiqJQj7x0=";
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
          buildCommand = "
            install -m444 -Dt $out/share/fonts/truetype $src/fonts/ttf/*.ttf $src/weights/*.ttf
          ";
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
