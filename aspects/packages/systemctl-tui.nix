{
  tack.inputs.systemctl-tui = {
    url = "gh:rgwood/systemctl-tui";
    patches = [
      "https://gist.githubusercontent.com/preprocessor/9cfc416aef8684374849a14284639be9/raw/5447789e89192e5ec6acdb959f88a20d0cbbd5a6/systemctl-tui_square_borders.patch"
    ];
    group = "tui";
    type = "fetch";
  };

  perSystem =
    {
      inputs,
      meta,
      pkgs,
      ...
    }:
    {
      remotePackages.systemctl-tui = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
        pname = "systemctl-tui";
        meta.mainProgram = finalAttrs.pname;
        version = meta.systemctl-tui.rev;
        src = inputs.systemctl-tui;
        cargoLock.lockFile = finalAttrs.src + "/Cargo.lock";
        doCheck = false;
        cargoBuildFlags = [
          "--config"
          "profile.release.strip=true"
        ];
        postInstall = "ln -s $out/bin/systemctl-tui $out/bin/sct";
      });
    };
}
