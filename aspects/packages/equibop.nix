{
  tack.inputs.equicord = {
    url = "gh:Equicord/Equicord";
    type = "fetch";
    frozen = true;
  };

  perSystem =
    {
      inputs,
      self',
      meta,
      pkgs,
      ...
    }:
    {
      packages.equicord = pkgs.equicord.overrideAttrs (
        finalAttrs: prevAttrs: {
          src = inputs.equicord;
          version = meta.equicord.rev;

          env = {
            EQUICORD_REMOTE = "Equicord/Equicord";
            EQUICORD_HASH = finalAttrs.version;
          };

          postPatch =
            let
              index = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/P3DROVFX/ii-p3drovfx/refs/heads/dev/dots/.config/quickshell/ii/scripts/discordVoice/vencord-companion/index.ts";
                sha256 = "sha256:09b51i1m25yraxhipihncrck8lzhdadjcxn6b6h6xsa39r2zk0g1";
              };

              native = builtins.fetchurl {
                url = "https://raw.githubusercontent.com/P3DROVFX/ii-p3drovfx/refs/heads/dev/dots/.config/quickshell/ii/scripts/discordVoice/vencord-companion/native.ts";
                sha256 = "sha256:1wxbm9878avkhxm8qzc79amm81mxkgq4j9s4ln4nm44f4glx7gig";
              };
            in
            # bash
            (prevAttrs.postPatch or "")
            + ''
              mkdir -p src/userplugins/quickshell
              cp "${index}" src/userplugins/quickshell/index.ts
              cp "${native}" src/userplugins/quickshell/native.ts
            '';

          pnpmDeps = pkgs.fetchPnpmDeps {
            pname = "equicord";
            inherit (finalAttrs) version src;
            pnpm = pkgs.pnpm_12;
            fetcherVersion = 5;
            hash = "sha256-bqjPMcJ31w77w1H3MuEwVdHBOSKedabpbaKFWmgUVy4=";
          };
        }
      );

      packages.equibop = pkgs.equibop.overrideAttrs (prevAttrs: {
        postPatch = (prevAttrs.postPatch or "") + ''
          substituteInPlace src/main/vencordDir.ts \
            --replace-fail ': join(SESSION_DATA_DIR, "equicord.asar");' ': "${self'.packages.equicord}/equibop";'
        '';
      });
    };
}
