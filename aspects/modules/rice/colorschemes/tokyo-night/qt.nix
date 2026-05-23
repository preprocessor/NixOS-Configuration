{
  w.desktop =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      tokyonightKvantum =
        {
          lib,
          stdenv,
          fetchFromGitHub,
        }:
        stdenv.mkDerivation {
          pname = "tokyo-night-kvantum";
          version = "0-unstable-2024-08-08";

          src = fetchFromGitHub {
            owner = "0xsch1zo";
            repo = "Kvantum-Tokyo-Night";
            rev = "82d104e0047fa7d2b777d2d05c3f22722419b9ee";
            hash = "sha256-Uy/WthoQrDnEtrECe35oHCmszhWg38fmDP8fdoXQgTk=";
          };
          installPhase = ''
            runHook preInstall
            mkdir -p $out/share/Kvantum
            cp -a Kvantum-Tokyo-Night $out/share/Kvantum
            runHook postInstall
          '';

          meta = {
            description = "Tokyo Night Kvantum theme";
            homepage = "https://github.com/0xsch1zo/Kvantum-Tokyo-Night";
            license = lib.licenses.gpl3Only;
            maintainers = with lib.maintainers; [
              iynaix
              wyspr
            ];
            mainProgram = "kvantum-tokyo-night";
            platforms = lib.platforms.all;
          };
        };

      tokyonightKvantumOverlay = f: p: {
        tokyo-night-kvantum = f.callPackage tokyonightKvantum { };
      };
    in
    # make qt use a dark theme, adapted from:
    # https://github.com/fufexan/dotfiles/blob/main/home/programs/qt.nix
    # also see:
    # https://discourse.nixos.org/t/struggling-to-configure-gtk-qt-theme-on-laptop/42268/
    {
      nixpkgs.overlays = [ tokyonightKvantumOverlay ];

      environment.systemPackages = with pkgs; [
        qt6Packages.qt6ct
        qt6Packages.qtstyleplugin-kvantum
        qt6Packages.qtwayland
      ];

      hj.environment.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_STYLE_OVERRIDE = "kvantum";
      };

      # use gtk theme on qt apps
      qt = {
        enable = true;
        platformTheme = "qt5ct";
        style = "kvantum";
      };

      hj.xdg.config.files = {
        # Kvantum
        "Kvantum/Kvantum-Tokyo-Night".source =
          "${pkgs.tokyo-night-kvantum}/share/Kvantum/Kvantum-Tokyo-Night";

        "Kvantum/kvantum.kvconfig" = {
          generator = lib.generators.toINI { };
          value = {
            General.theme = "Kvantum-Tokyo-Night";
          };
        };
      };
    };
}
