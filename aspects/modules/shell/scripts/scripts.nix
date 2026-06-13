{
  w.default =
    { pkgs, birdee, ... }:
    {
      hj.packages = [
        (pkgs.writeShellScriptBin "eye" ./bin/eye)
        (pkgs.writeShellScriptBin "gbc" ./bin/gbc)
        (pkgs.writeShellScriptBin "moon" ./bin/moon)
        (birdee.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.writeShellScriptBin "waow" ./bin/waow;
          aliases = [
            "wot"
            "huh"
            "hmm"
            "wystem"
          ];
          runtimePkgs = with pkgs; [
            fetchutils
            xrandr
            xprop
          ];
        })
      ];
    };
}
