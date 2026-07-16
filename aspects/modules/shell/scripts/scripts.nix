{
  exo.core =
    { pkgs, wrapPackage, ... }:
    {
      hj.packages = [
        (pkgs.writeShellScriptBin "eye" ./bin/eye)
        (pkgs.writeShellScriptBin "gbc" ./bin/gbc)
        (pkgs.writeShellScriptBin "moon" ./bin/moon)
        (wrapPackage {
          package = pkgs.writeShellScriptBin "waow" ./bin/waow;
          aliases = [
            "wystem"
            "wot"
            "huh"
            "hmm"
          ];
          extraPkgs = with pkgs; [
            fetchutils
            xrandr
            xprop
          ];
        })
      ];
    };
}
