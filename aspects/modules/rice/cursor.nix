{
  w.desktop =
    { pkgs, ... }:
    {
      my.gtk.cursor = {
        package = pkgs.posy-cursors;
        name = "Posy_Cursor_Black";
        size = 32;
      };
    };
}
