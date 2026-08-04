{
  exo.core =
    { pkgs, lib, ... }:
    {
      my.xdg.desktopTuiEntries."Cyme" = {
        package = pkgs.writeShellScriptBin "cyme-script" "${lib.getExe pkgs.cyme} --headings --tree --hide-buses; read -p 'Press ENTER to exit. '";
        width = 1200;
        height = 600;
      };
    };
}
