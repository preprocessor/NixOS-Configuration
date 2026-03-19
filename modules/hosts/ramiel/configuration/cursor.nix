{ inputs, ... }:
{
  flake.modules.homeManager.ramiel =
    { pkgs, ... }:
    {
      # home.pointerCursor = {
      #   gtk.enable = true;
      #   x11.enable = true;
      # };
      #
      # stylix.cursor = {
      #   package = pkgs.hand_of_evil;
      #   name = "hand-of-evil";
      #   size = 24;
      # };
    };
}
