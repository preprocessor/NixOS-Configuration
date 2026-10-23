{
  perSystem = { pkgs, lib, ... }: {
    legacyPackages = {
      retrosmart-classic-extra = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "retrosmart-classic-extra-cursors";
        version = "2.0.3";
        __structuredAttrs = true;
        strictDeps = true;

        src = pkgs.fetchzip {
          url = "https://github.com/useless-anvil/retrosmart-cursor/releases/download/v${finalAttrs.version}/retrosmart-cursor-extras-v${finalAttrs.version}-linux.tar.gz";
          hash = "sha256-GvGjdmoRGvy/vzkqjNNpvAxTyoqOpKohMa7XPaos4xo=";
          stripRoot = false;
        };

        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/icons
          cp -r * $out/share/icons
          runHook postInstall
        '';

        meta = {
          description = ''An "8-bit-esque" X11 cursor theme, inspired by old Windows 3.x and classic OS X cursors.'';
          homepage = "https://github.com/useless-anvil/retrosmart-cursor";
          platforms = lib.platforms.all;
          license = lib.licenses.gpl3Only;
          maintainers = with lib.maintainers; [ wyspr ];
        };
      });

      retrosmart-classic = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "retrosmart-classic-cursors";
        version = "2.0.3";
        __structuredAttrs = true;
        strictDeps = true;

        src = pkgs.fetchzip {
          url = "https://github.com/useless-anvil/retrosmart-cursor/releases/download/v${finalAttrs.version}/retrosmart-cursor-classic-v${finalAttrs.version}-linux.tar.gz";
          hash = "sha256-wV3IJb+xR5ncKRvoDpwIxrD93Ol/OM0mnecrm3qXSPU=";
          stripRoot = false;
        };

        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/icons
          cp -r * $out/share/icons
          runHook postInstall
        '';

        meta = {
          description = ''An "8-bit-esque" X11 cursor theme, inspired by old Windows 3.x and classic OS X cursors.'';
          homepage = "https://github.com/useless-anvil/retrosmart-cursor";
          platforms = lib.platforms.all;
          license = lib.licenses.gpl3Only;
          maintainers = with lib.maintainers; [ wyspr ];
        };
      });
    };
  };

  exo.mods.desktop =
    { self', ... }:
    {

      hj.packages = [ self'.legacyPackages.retrosmart-classic-extra ];

      my.gtk.cursor = {
        package = self'.legacyPackages.retrosmart-classic;
        name = "retrosmart-xcursor-mac-ish-white-shadow";
        size = 32;
      };
    };
}
