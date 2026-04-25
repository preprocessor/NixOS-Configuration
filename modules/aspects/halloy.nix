{
  w.default =
    { pkgs, ... }:
    {
      hj.packages = with pkgs; [
        halloy
      ];
    };
}
