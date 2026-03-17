{ inputs, ... }:
{
  flake.modules.homeManager.ramiel =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
      };

      stylix.cursor = {
        package = pkgs.miku_cursor;
        name = "Miku Cursor";
        size = 24;
      };
    };
}
