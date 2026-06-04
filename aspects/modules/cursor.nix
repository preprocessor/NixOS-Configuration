{
  w.desktop =
    { pkgs, ... }:
    {
      custom.gtk.cursor = {
        package = pkgs.posy-cursors;
        name = "Posy_Cursor_Black";
        size = 32;
      };
    };
}
