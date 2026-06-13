{
  perSystem =
    { pkgs, lib, ... }:
    {

      packages.stfu = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "stfu-notify";
        version = "0-unstable-2022-05-23";
        __structuredAttrs = true;

        src = pkgs.fetchFromGitHub {
          owner = "callb4ck";
          repo = "stfu-notify";
          rev = "bb08c0d93c9f573277f16bfd2d30645e2820a36b";
          hash = "sha256-8t8QyI+fDgwGJLF3k4WR+IlbZOpMpQ0GLa7E3+j9da4=";
        };

        cargoHash = "sha256-L7SImWLGKD/BGY9XcVIQ1KqOOiLIlP+j4paUKJSqw9w=";

        nativeBuildInputs = with pkgs; [
          pkg-config
          cmake
          git
          gcc
          libcerf
          pango
          cairo
          libGL
          mesa
          pkg-config

          fltk
        ];

        buildInputs = with pkgs; [
          libXext
          libXft
          libXinerama
          libXcursor
          libXrender
          libXfixes
        ];

        passthru.updateScript = pkgs.nix-update-script { };

        meta = {
          description = "A notification daemon with a cli client and a gui pop-up";
          homepage = "https://github.com/callb4ck/stfu-notify";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ wyspr ];
          mainProgram = "stfu-notify";
        };
      });
    };
}
