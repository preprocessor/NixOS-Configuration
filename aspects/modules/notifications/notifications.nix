{
  tack.histui = {
    url = "https://github.com/jmylchreest/histui/archive/refs/tags/v0.0.14.tar.gz";
    type = "fixed";
  };

  perSystem =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    {
      packages.histui = pkgs.buildGoModule (final: {
        pname = "histui";
        version = "v0.0.14";
        __structuredAttrs = true;
        allowSubstitutes = false;
        preferLocalBuild = true;
        src = inputs.histui;
        vendorHash = "sha256-b5CFO2UEzaMlTK1I4r+/5LAQNseClZirpwpjb0ne9Cc=";
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
          install -m755 -Dt $out/bin histui histuid
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

  exo.mods.desktop =
    { self', pkgs, ... }:
    {
      hj.packages = [
        self'.packages.histui
        pkgs.libnotify # notify-send
      ];

      my.hyprland.startup = [
        ''hl.exec_cmd("${self'.packages.histui}/bin/histuid")''
      ];

      my.hyprland.lua.files."layer_rules.histui".content = /* lua */ ''
        hl.layer_rule({
          match        = { namespace = "^histui-notification$" },
          no_screen_share = true,
          ignore_alpha = 0.3,
          blur         = true,
          blur_popups  = true,
          animation    = "slide bottom"
        })
      '';
    };
}
