{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.nsakura = pkgs.buildNimPackage (finalAttrs: {
        pname = "nsakura";
        version = "0.1.0";
        __structuredAttrs = true;
        strictDeps = true;

        src = pkgs.fetchFromGitHub {
          owner = "KornelHajto";
          repo = "nsakura";
          tag = "v${finalAttrs.version}";
          hash = "sha256-/PAcHS0Yxhwp76FlyQXvBmlcSvaOsLtBEbgAKmmASIg=";
        };

        passthru.updateScript = pkgs.nix-update-script { };

        meta = {
          description = "";
          homepage = "https://github.com/KornelHajto/nsakura";
          changelog = "https://github.com/KornelHajto/nsakura/releases/tag/${finalAttrs.src.tag}";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ wyspr ];
          mainProgram = "nsakura";
          platforms = lib.platforms.all;
        };
      });
    };
}
