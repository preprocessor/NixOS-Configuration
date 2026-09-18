{
  tack.inputs.hyprland-scroll-overview = {
    url = "gh:yayuuu/hyprland-scroll-overview/new-release";
    type = "fetch";
  };

  perSystem =
    {
      packages',
      inputs,
      pkgs,
      ...
    }:
    {
      packages.scrolloverview = packages'.hyprland.stdenv.mkDerivation {
        pname = "scrolloverview";
        version = "1.0";
        src = inputs.hyprland-scroll-overview;

        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [
          pkgs.lua5_4
          packages'.hyprland
        ]
        ++ packages'.hyprland.buildInputs;

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
          platforms = packages'.hyprland.meta.platforms or [ ];
        };
      };
    };

  exo.mods.desktop =
    { self', ... }:
    {
      my.hyprland.plugins = { inherit (self'.packages) scrolloverview; };

      my.hyprland.lua.files."plugins/scrolloverview".content = /* lua */ ''
        hl.on("config.reloaded", function()
          if utils.is_plugin_loaded("scrolloverview") then
            hl.bind("SUPER + Tab", function()
              hl.plugin.scrolloverview.overview("toggle all")
            end)

            hl.config({
              plugin = {
                scrolloverview = {
                  workspace_gap = 100,
                  wallpaper = 2,
                  blur = true,
                  shadow = {
                    enabled = true,
                  },
                },
              },
            })
          end
        end)
      '';
    };
}
