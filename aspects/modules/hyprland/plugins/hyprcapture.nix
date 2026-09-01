{
  tack.inputs.hyprland-hyprcapture = {
    url = "gh:gfhdhytghd/HyprCapture";
    type = "fetch";
  };

  perSystem =
    {
      pkgs,
      inputs,
      lib,
      ...
    }:
    {
      remotePackages.hyprcapture = pkgs.hyprland.stdenv.mkDerivation (finalAttrs: {
        pname = "hyprcapture";
        version = "0.2.7";
        src = inputs.hyprland-hyprcapture;

        nativeBuildInputs = with pkgs; [
          kdePackages.wrapQtAppsHook
          pkg-config
          cmake
        ];

        buildInputs =
          pkgs.hyprland.buildInputs
          ++ (with pkgs; [
            kdePackages.layer-shell-qt
            kdePackages.qtbase
            kdePackages.qtsvg
            nlohmann_json
            hyprland
            glib
            lua
          ]);

        enableParallelBuilding = true;
        dontUseCmakeConfigure = true;

        cmakeFlags = [
          "-DHYPRCAPTURE_DEFAULT_HELPER_PATH=${placeholder "out"}/bin/hyprcapture-ui"
          "-DHYPRCAPTURE_TRUSTED_BIN_DIRS=${lib.makeBinPath [ pkgs.hyprland ]}"
        ];

        preCheck = ''
          export QT_QPA_PLATFORM=offscreen
        '';

        buildPhase = ''
          runHook preBuild
          cmake -DCMAKE_BUILD_TYPE=Release -B build-cmake
          cmake --build build-cmake -j"$(nproc)"
          ctest --test-dir build-cmake --output-on-failure
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          install -m555 -DT build-cmake/libhyprcapture.so "$out/lib/libhyprcapture.so"
          install -m555 -DT build-cmake/hyprcapture-ui "$out/bin/hyprcapture-ui"
          runHook postInstall
        '';

        meta = {
          homepage = "https://github.com/gfhdhytghd/HyprCapture";
          description = "Hyprland-only screenshot and recording tool";
          license = lib.licenses.gpl3Only;
          inherit (pkgs.hyprland.meta) platforms;
          mainProgram = "hyprcapture-ui";
        };
      });
    };

  exo.mods.desktop =
    { self', ... }:
    {
      my.hyprland.plugins = { inherit (self'.packages) hyprcapture; };

      my.hyprland.lua.files."plugins/hyprcapture".content = /* lua */ ''
        hl.bind("Print", hl.plugin.hyprcapture.open)

        hl.config({
          plugin = {
            hyprcapture = {
              default_mode = "region",
              fullscreen_scope = "current",
              overlay_scope = "fix",
              window_background = "transparent",
              window_border = "keep",
              window_shadow = "remove",
              notification_backend = "hyprland",
              screenshot_notification = true,
              notification_title_template = "Screenshot captured",
              notification_body_template = "Saved {filename} ({window_title})",
              save = true,
              clipboard = true,
              show_thumbnail = true,
              fusion_mode = true,
              capture_fullscreen_clients_as_monitor = false,
              dynamic_window_metadata = true,
              window_wheel_scroll = true,
              save_dir = "$XDG_PICTURES_DIR/Screenshots",
              filename_template = "Screenshot-%Y-%m-%d-%H:%M:%S.png",
              record_save_dir = "$XDG_VIDEOS_DIR/Screenrecords",
              helper = "${self'.packages.hyprcapture}/bin/hyprcapture-ui",
            },
          },
        })
      '';

    };
}
