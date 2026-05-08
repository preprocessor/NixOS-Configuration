{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.cclip = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "cclip";
        version = "3.3.1";

        src = pkgs.fetchFromGitHub {
          owner = "heather7283";
          repo = "cclip";
          tag = finalAttrs.version;
          hash = "sha256-rjDCYag0aG9mZuwzWNS5z/CzeEtpdjc9iMypKqIZK60=";
        };

        nativeBuildInputs = with pkgs; [
          meson
          ninja
          pkg-config
          git
          sqlite
          wayland
          xxhash
          wayland-scanner
        ];

        meta = {
          description = "Clipboard manager for wayland";
          homepage = "https://github.com/heather7283/cclip";
          license = lib.licenses.gpl3Only;
          maintainers = with lib.maintainers; [
            wyspr
            onelocked
          ];
          mainProgram = "cclip";
          platforms = lib.platforms.all;
        };
      });
    };

  w.default =
    { self', ... }:
    {
      hj.packages = [ self'.packages.cclip ];
    };
}
