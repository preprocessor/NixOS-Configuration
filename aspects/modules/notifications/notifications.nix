{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.histui = pkgs.buildGoModule (final: {
        pname = "histui";
        version = final.src.tag;
        __structuredAttrs = true;
        src = pkgs.fetchFromGitHub {
          owner = "jmylchreest";
          repo = "histui";
          tag = "v0.0.11";
          hash = "sha256-xBAS81eWuxABQRLfWUR/xH9bHUq/OoFmjmAsRr3kts4=";
        };
        vendorHash = "sha256-2WPZwP0G6STb2jF7Hy/7/fUyWbXTcdlokp18E8U60bc=";
        doCheck = false;

        nativeBuildInputs = with pkgs; [
          pkg-config
          gobject-introspection
        ];

        buildInputs = with pkgs; [
          gtk4
          libadwaita
          gtk4-layer-shell
          alsa-lib
        ];

        buildPhase = ''
          runHook preBuild

          CGO_ENABLED=0 go build -x -v -ldflags "-s -w" -o histui ./cmd/histui
          CGO_ENABLED=1 go build -x -v -ldflags "-s -w" -o histuid ./cmd/histuid

          runHook postBuild
        '';

        installPhase = ''
          install -m755 -Dt $out/bin histui
          install -m755 -Dt $out/bin histuid
        '';

        meta = {
          description = "GTK4 notification daemon for Wayland with persistent history";
          homepage = "https://github.com/jmylchreest/histui";
          changelog = "https://github.com/jmylchreest/histui/releases/tag/${final.src.tag}";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ wyspr ];
        };
      });
    };

  w.desktop =
    { self', ... }:
    {
      hj.packages = [ self'.packages.histui ];
    };
}
