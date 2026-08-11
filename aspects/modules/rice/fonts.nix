{
  tack = {
    shorturls.applefont = "https://devimages-cdn.apple.com/design/resources/download/{path}.dmg";

    inputs = {
      sf-pro = {
        url = "applefont:SF-Pro";
        type = "fixed";
      };
      sf-mono = {
        url = "applefont:SF-Mono";
        type = "fixed";
      };
      sf-compact = {
        url = "applefont:SF-Compact";
        type = "fixed";
      };
      ny = {
        url = "applefont:NY";
        type = "fixed";
      };

      fragment-mono = {
        url = "gh:dtinth/fragment-mono-weights";
        type = "fetch";
      };
      chicago-font = {
        url = "gh:nikdog/chicago-font";
        type = "fetch";
      };
      helvetica-font = {
        url = "gh:Kyles-World/Helvetica-Font";
        type = "fetch";
      };
    };
  };

  perSystem =
    { pkgs, inputs, ... }:
    let
      makeAppleFont =
        name: pkgName: src:
        pkgs.stdenvNoCC.mkDerivation {
          inherit name src;
          allowSubstitutes = false;
          preferLocalBuild = true;
          unpackPhase = # bash
            ''
              7z x $src
              7z x './*/${pkgName}'
              7z x 'Payload~'
            '';

          nativeBuildInputs = [ pkgs.p7zip ];

          setSourceRoot = "sourceRoot=`pwd`";

          installPhase = # bash
            ''
              find . -name '*.otf' -exec install -Dm644 -t "$out/share/fonts/opentype" {} +
              find . -name '*.ttf' -exec install -Dm644 -t "$out/share/fonts/truetype" {} +
            '';
        };

      mkFont =
        pname: src: buildCommand:
        pkgs.stdenvNoCC.mkDerivation {
          allowSubstitutes = false;
          preferLocalBuild = true;
          inherit pname src buildCommand;
          version = "0.1";

          dontUnpack = true;
          dontBuild = true;
          dontConfigure = true;
        };
    in
    {
      legacyPackages = {
        apple-fonts =
          let
            fonts = {
              sf-pro = makeAppleFont "sf-pro" "SF Pro Fonts.pkg" inputs.sf-pro;
              sf-mono = makeAppleFont "sf-mono" "SF Mono Fonts.pkg" inputs.sf-mono;
              sf-compact = makeAppleFont "sf-compact" "SF Compact Fonts.pkg" inputs.sf-compact;
              ny = makeAppleFont "ny" "NY Fonts.pkg" inputs.ny;
            };
          in
          pkgs.symlinkJoin {
            name = "apple-fonts";
            paths = builtins.attrValues fonts;
            passthru = fonts;
          };

        helvetica-font =
          mkFont "helvetica-font" inputs.helvetica-font
            ''install -m444 -Dt $out/share/fonts/truetype $src/Helvetica\ World\ \(Unicode\)/*.ttf'';

        chicago-font =
          mkFont "chicago-font" inputs.chicago-font
            ''install -m444 -Dt $out/share/fonts/truetype "$src/Chicago v0.5.5.ttf"'';

        fragment-mono-font =
          mkFont "fragment-mono" inputs.fragment-mono
            "install -m444 -Dt $out/share/fonts/truetype $src/fonts/ttf/*.ttf $src/weights/*.ttf";
      };
    };

  exo.mods.desktop =
    { self', pkgs, ... }:
    {
      hj.packages = [ pkgs.font-manager ];

      fonts.packages = [ self'.legacyPackages.helvetica-font ];

      my.gtk.fonts = {
        serif = {
          name = "New York";
          package = self'.legacyPackages.apple-fonts.ny;
        };

        sans = {
          name = "SF Pro Display";
          package = self'.legacyPackages.apple-fonts.sf-pro;
        };

        mono = {
          package = self'.legacyPackages.apple-fonts.sf-mono;
          name = "SF Mono";
        };

        emoji = {
          name = "Blobmoji";
          package = pkgs.noto-fonts-emoji-blob-bin;
        };
      };

      _file = ./fonts.nix;
    };

  exo.host.ramiel =
    { self', ... }:
    {
      fonts.packages = with self'.legacyPackages; [
        chicago-font
        fragment-mono-font
      ];
    };
}
