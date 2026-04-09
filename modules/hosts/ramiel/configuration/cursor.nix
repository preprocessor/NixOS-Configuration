{
  flake.modules.homeManager.ramiel =
    { pkgs, ... }:
    {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
      };

      stylix.cursor = {
        package = pkgs.posy-cursors;
        name = "Posy_Cursor_Black";
        size = 128;
      };
    };
}
