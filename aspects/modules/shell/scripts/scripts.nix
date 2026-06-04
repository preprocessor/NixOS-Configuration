{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = [
        (pkgs.writeShellScriptBin "eye" ./bin/eye)
        (pkgs.writeShellScriptBin "gbc" ./bin/gbc)
        (pkgs.writeShellScriptBin "moon" ./bin/moon)
        (pkgs.writeShellScriptBin "waow" ./bin/waow)
      ];
    };
}
