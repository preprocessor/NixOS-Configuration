{
  tack.inputs.hyprland-scroll-overview = {
    url = "gh:yayuuu/hyprland-scroll-overview";
    type = "fetch";
  };

  perSystem =
    { inputs, pkgs, ... }:
    {
      remotePackages.scrolloverview = pkgs.hyprland.stdenv.mkDerivation (finalAttrs: {
        pname = "scrolloverview";
        version = "1.0";
        src = inputs.hyprland-scroll-overview;

        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs =
          with pkgs;
          [
            lua5_4
            hyprland
          ]
          ++ pkgs.hyprland.buildInputs;

        enableParallelBuilding = true;
        dontUseCmakeConfigure = true;

        buildPhase = ''
          runHook preBuild
          export SCROLLOVERVIEW_BUILD_VERSION="1.0"
          make all
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          install -m555 -DT scrolloverview.so "$out/lib/libscrolloverview.so"
          runHook postInstall
        '';

        meta = {
          homepage = "https://github.com/yayuuu/hyprland-scroll-overview";
          description = "scroll overview";
          platforms = pkgs.hyprland.meta.platforms or [ ];
        };
      });
    };

  exo.mods.desktop = {
    my.hyprland.lua.files."plugins/scrolloverview".content = /* lua */ ''
      hl.bind("SUPER + Tab", function()
        hl.plugin.scrolloverview.overview("toggle all")
      end)
    '';
  };
}
