{
  exo.core =
    { pkgs, wrapPackage, ... }:
    {
      hj.packages = [
        (pkgs.writeShellScriptBin "moon" ./bin/moon)

        (wrapPackage {
          package = pkgs.writeShellScriptBin "waow" ./bin/waow;
          env.CLICOLOR_FORCE = 1;

          linkedPackages = [
            (pkgs.writeShellScriptBin "eye" ./bin/eye)
            (pkgs.writeShellScriptBin "gbc" ./bin/gbc)
            (wrapPackage {
              package = pkgs.writeShellScriptBin "wystem" ./bin/wystem;
              runtimePackages = with pkgs; [
                fetchutils
                xrandr
                xprop
              ];
            })
          ];

          aliases = [
            "wot"
            "huh"
            "hmm"
          ];
        })
      ];
    };
}
