{
  tack.inputs.hyprland-scroll-overview = {
    url = "gh:yayuuu/hyprland-scroll-overview";
    type = "fetch";
  };

  exo.mods.desktop =
    {
      inputs,
      config,
      pkgs,
      ...
    }:
    let
      hyprland = config.my.hyprland.package;
    in
    {
      my.hyprland.lua.files."plugins/scrolloverview".content = /* lua */ ''
        hl.bind("SUPER + Tab", function()
          hl.plugin.scrolloverview.overview("toggle all")
        end)
      '';

      my.hyprland.plugins.scrolloverview = hyprland.stdenv.mkDerivation (finalAttrs: {
        pname = "scrolloverview";
        version = "1.0";
        src = inputs.hyprland-scroll-overview;

        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = hyprland.buildInputs ++ [
          pkgs.lua5_4
          hyprland
        ];

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
          platforms = hyprland.meta.platforms or [ ];
        };
      });
    };
}
