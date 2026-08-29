{
  # perSystem =
  #   { pkgs, ... }:
  #   {
  #     packages.shadps4 =
  #       let
  #         pname = "shadPS4QtLauncher";
  #         rev = "a30486c3e0a17460c44cf1caf15559c6f3331e57";
  #         version = "2026-08-18-a30486c";
  #
  #         zipSrc = pkgs.fetchurl {
  #           url = "https://github.com/shadps4-emu/shadps4-qtlauncher/releases/download/shadPS4QtLauncher-2026-08-18-${rev}/shadPS4QtLauncher-linux-qt-${version}.zip";
  #           hash = "sha256-jJHdhwYHIOWGFGhu5EmGOuxU70FjShEhK88Cs/cld/k=";
  #         };
  #
  #         appimageSrc =
  #           pkgs.runCommand "${pname}-qt.AppImage"
  #             {
  #               nativeBuildInputs = [ pkgs.unzip ];
  #             }
  #             ''
  #               unzip ${zipSrc}
  #
  #               cp shadPS4QtLauncher-qt.AppImage $out
  #             '';
  #       in
  #       pkgs.appimageTools.wrapType2 {
  #         inherit pname version;
  #         src = appimageSrc;
  #         extraPkgs = pkgs: [ pkgs.at-spi2-core ];
  #       };
  #   };

  exo.mods.gaming =
    { pkgs, ... }:
    {
      hj.packages = [ pkgs.shadps4 ];
    };
}
