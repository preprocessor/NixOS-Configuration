{ config, lib, ... }:
let
  resize = config.utils.otterResize;
in
{
  w.default =
    { self', ... }:
    {
      wrappers.otter-launcher.settings.modules = [
        {
          description = "pokedex";
          prefix = "dex";
          cmd = resize 1200 880 (lib.getExe self'.packages.poketex);
        }
      ];

    };

  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.poketex = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "poketex";
        version = "1.17.0";

        src = pkgs.fetchFromGitHub {
          owner = "ckaznable";
          repo = "poketex";
          tag = "v${finalAttrs.version}";
          hash = "sha256-o7xw0cyf4O8b7T7TwXte5GX2zgcTYIKgKiiJkbbI4PI=";
        };

        cargoHash = "sha256-Nn25XHSv/mjS30yYy3ikQ2Oms+WPBxNIwHqQ34i8D9Q=";

        postPatch = ''
          substituteInPlace src/main.rs \
            --replace-fail '"/usr/share/poketex"' '"${placeholder "out"}/share/poketex"' \
            --replace-fail '"/usr/local/share/poketex"' '"${placeholder "out"}/share/poketex"'
        '';

        postInstall = ''
          mkdir -p $out/share/poketex/colorscripts
          cp -rf $src/colorscripts $out/share/poketex
        '';

        meta = {
          description = "Simple Pokedex based on TUI";
          homepage = "https://github.com/ckaznable/poketex";
          license = lib.licenses.mit;
          mainProgram = "poketex";
        };
      });
    };
}
