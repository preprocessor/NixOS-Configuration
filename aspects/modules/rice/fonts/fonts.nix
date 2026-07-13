{ inputs, ... }:
{
  tack = {
    apple-fonts.url = "gh:Lyndeno/apple-fonts.nix";

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

  exo.mods.desktop =
    {
      packages',
      pkgs,
      ...
    }:
    {
      hj.packages = [ pkgs.font-manager ];

      fonts.packages = [
        (pkgs.stdenvNoCC.mkDerivation {
          src = inputs.helvetica-font;
          pname = "helvetica-font";
          version = "0.1";

          dontUnpack = true;
          dontBuild = true;
          dontConfigure = true;
          buildCommand = ''install -m444 -Dt $out/share/fonts/truetype $src/Helvetica\ World\ \(Unicode\)/*.ttf'';
        })
      ];

      my.gtk.fonts = {
        serif = {
          name = "New York";
          package = packages'.apple-fonts.ny;
        };

        sans = {
          name = "SF Pro Display";
          package = packages'.apple-fonts.sf-pro;
        };

        mono = {
          name = "SF Mono Regular";
          package = packages'.apple-fonts.sf-mono;
        };

        emoji = {
          name = "Blobmoji";
          package = pkgs.noto-fonts-emoji-blob-bin;
        };
      };

      _file = ./fonts.nix;
    };

  exo.host.ramiel =
    {
      pkgs,
      ...
    }:
    {
      fonts.packages = [
        (pkgs.stdenvNoCC.mkDerivation {
          src = inputs.chicago-font;
          pname = "chicago-font";
          version = "0.1";

          dontUnpack = true;
          dontBuild = true;
          dontConfigure = true;
          buildCommand = ''install -m444 -Dt $out/share/fonts/truetype "$src/Chicago v0.5.5.ttf"'';
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
          src = inputs.fragment-mono;
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
    };
}
